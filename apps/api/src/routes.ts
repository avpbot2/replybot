import { Router, type Response } from "express";
import bcrypt from "bcryptjs";
import { z } from "zod";
import type { ResultSetHeader, RowDataPacket } from "mysql2";
import { pool } from "./db.js";
import { requireAuth, signToken, type AuthenticatedRequest } from "./auth.js";

export const router = Router();

const registerSchema = z.object({
  name: z.string().trim().min(2).max(100),
  workspaceName: z.string().trim().min(2).max(120),
  email: z.string().trim().email().max(254),
  password: z.string().min(10).max(72)
});
const loginSchema = z.object({
  email: z.string().trim().email().max(254),
  password: z.string().min(1).max(72)
});

function sendValidationError(res: Response, error: z.ZodError): void {
  res.status(400).json({ error: "Invalid request", details: error.flatten().fieldErrors });
}

router.post("/auth/register", async (req, res, next) => {
  const parsed = registerSchema.safeParse(req.body);
  if (!parsed.success) return sendValidationError(res, parsed.error);

  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();
    const [existing] = await connection.execute<RowDataPacket[]>(
      "SELECT id FROM users WHERE email = ? LIMIT 1",
      [parsed.data.email.toLowerCase()]
    );
    if (existing.length) {
      await connection.rollback();
      res.status(409).json({ error: "An account with this email already exists" });
      return;
    }

    const passwordHash = await bcrypt.hash(parsed.data.password, 12);
    const [workspaceResult] = await connection.execute<ResultSetHeader>(
      "INSERT INTO workspaces (name) VALUES (?)",
      [parsed.data.workspaceName]
    );
    const [userResult] = await connection.execute<ResultSetHeader>(
      "INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)",
      [parsed.data.name, parsed.data.email.toLowerCase(), passwordHash]
    );
    await connection.execute(
      "INSERT INTO workspace_members (workspace_id, user_id, role) VALUES (?, ?, 'owner')",
      [workspaceResult.insertId, userResult.insertId]
    );
    await connection.commit();
    const user = {
      id: userResult.insertId,
      workspaceId: workspaceResult.insertId,
      email: parsed.data.email.toLowerCase()
    };
    res.status(201).json({ token: signToken(user), user: { ...user, name: parsed.data.name } });
  } catch (error) {
    await connection.rollback();
    next(error);
  } finally {
    connection.release();
  }
});

router.post("/auth/login", async (req, res, next) => {
  const parsed = loginSchema.safeParse(req.body);
  if (!parsed.success) return sendValidationError(res, parsed.error);
  try {
    const [rows] = await pool.execute<RowDataPacket[]>(
      `SELECT u.id, u.name, u.email, u.password_hash, wm.workspace_id AS workspaceId
       FROM users u JOIN workspace_members wm ON wm.user_id = u.id
       WHERE u.email = ? ORDER BY wm.id LIMIT 1`,
      [parsed.data.email.toLowerCase()]
    );
    const account = rows[0];
    if (!account || !(await bcrypt.compare(parsed.data.password, account.password_hash))) {
      res.status(401).json({ error: "Email or password is incorrect" });
      return;
    }
    const user = {
      id: Number(account.id),
      workspaceId: Number(account.workspaceId),
      email: String(account.email)
    };
    res.json({
      token: signToken(user),
      user: { ...user, name: String(account.name) }
    });
  } catch (error) {
    next(error);
  }
});

router.get("/health", async (_req, res, next) => {
  try {
    await pool.query("SELECT 1");
    res.json({ status: "ok", database: "connected" });
  } catch (error) {
    next(error);
  }
});

router.use(requireAuth);

const resources = {
  agents: {
    table: "agents",
    columns: ["id", "name", "purpose", "status", "tone", "created_at"],
    create: ["name", "purpose", "tone", "status"] as const,
    insertColumns: ["name", "purpose", "tone", "status"] as const
  },
  leads: {
    table: "leads",
    columns: ["id", "name", "email", "phone", "source", "status", "created_at"],
    create: ["name", "email", "phone", "source"] as const,
    insertColumns: ["name", "email", "phone", "source"] as const
  },
  bookings: {
    table: "bookings",
    columns: ["id", "customer_name", "service", "starts_at", "status", "created_at"],
    create: ["customer_name", "service", "starts_at"] as const,
    insertColumns: ["customer_name", "service", "starts_at"] as const
  },
  campaigns: {
    table: "campaigns",
    columns: ["id", "name", "channel", "status", "scheduled_at", "created_at"],
    create: ["name", "channel", "scheduled_at"] as const,
    insertColumns: ["name", "channel", "scheduled_at"] as const
  },
  knowledge: {
    table: "knowledge_documents",
    columns: ["id", "title", "source_type", "status", "created_at"],
    create: ["title", "source_type", "content"] as const,
    insertColumns: ["title", "source_type", "content"] as const
  },
  channels: {
    table: "channels",
    columns: ["id", "name", "provider", "status", "created_at"],
    create: ["name", "provider"] as const,
    insertColumns: ["name", "provider"] as const
  },
  flows: {
    table: "automation_flows",
    columns: ["id", "name", "trigger_type", "status", "created_at"],
    create: ["name", "trigger_type"] as const,
    insertColumns: ["name", "trigger_type"] as const
  },
  templates: {
    table: "templates",
    columns: ["id", "name", "channel", "body", "status", "created_at"],
    create: ["name", "channel", "body"] as const,
    insertColumns: ["name", "channel", "body"] as const
  },
  contacts: {
    table: "contacts",
    columns: ["id", "name", "email", "phone", "source", "created_at"],
    create: ["name", "email", "phone"] as const,
    insertColumns: ["name", "email", "phone"] as const
  },
  orders: {
    table: "orders",
    columns: ["id", "order_reference", "amount", "currency", "status", "created_at"],
    create: ["order_reference", "amount", "currency"] as const,
    insertColumns: ["order_reference", "amount", "currency"] as const
  }
} as const;

type ResourceName = keyof typeof resources;
function isResourceName(value: string): value is ResourceName {
  return Object.hasOwn(resources, value);
}

router.get("/overview", async (req: AuthenticatedRequest, res, next) => {
  try {
    const workspaceId = req.user!.workspaceId;
    const [rows] = await pool.execute<RowDataPacket[]>(
      `SELECT
        (SELECT COUNT(*) FROM conversations WHERE workspace_id = ? AND status <> 'closed') AS open_conversations,
        (SELECT COUNT(*) FROM leads WHERE workspace_id = ? AND status <> 'won') AS active_leads,
        (SELECT COUNT(*) FROM agents WHERE workspace_id = ? AND status = 'active') AS active_agents,
        (SELECT COUNT(*) FROM bookings WHERE workspace_id = ? AND starts_at >= UTC_TIMESTAMP() AND status = 'confirmed') AS upcoming_bookings`,
      [workspaceId, workspaceId, workspaceId, workspaceId]
    );
    const [recent] = await pool.execute<RowDataPacket[]>(
      `SELECT c.id, c.subject, c.channel, c.status, c.updated_at,
              COALESCE(ct.name, 'New contact') AS contact_name
       FROM conversations c LEFT JOIN contacts ct ON ct.id = c.contact_id
       WHERE c.workspace_id = ? ORDER BY c.updated_at DESC LIMIT 5`,
      [workspaceId]
    );
    res.json({ metrics: rows[0], recentConversations: recent });
  } catch (error) {
    next(error);
  }
});

router.get("/:resource", async (req: AuthenticatedRequest, res, next) => {
  const resourceName = req.params.resource;
  if (!isResourceName(resourceName)) {
    res.status(404).json({ error: "Resource not found" });
    return;
  }
  const resource = resources[resourceName];
  try {
    const [rows] = await pool.execute<RowDataPacket[]>(
      `SELECT ${resource.columns.join(", ")} FROM ${resource.table}
       WHERE workspace_id = ? ORDER BY id DESC LIMIT 100`,
      [req.user!.workspaceId]
    );
    res.json({ items: rows });
  } catch (error) {
    next(error);
  }
});

router.post("/:resource", async (req: AuthenticatedRequest, res, next) => {
  const resourceName = req.params.resource;
  if (!isResourceName(resourceName)) {
    res.status(404).json({ error: "Resource not found" });
    return;
  }
  const resource = resources[resourceName];
  const values = resource.insertColumns.map((column) => {
    const value = req.body?.[column];
    if (typeof value !== "string") return value;
    const trimmed = value.trim();
    return trimmed ? trimmed : null;
  });
  const requiredCount = resourceName === "knowledge" || resourceName === "templates" ? 3 :
    resourceName === "leads" || resourceName === "contacts" ? 1 :
      resourceName === "orders" ? 1 : 2;
  if (values.slice(0, requiredCount).some((value) => typeof value !== "string" || !value)) {
    res.status(400).json({ error: "Required fields are missing" });
    return;
  }
  if (values.some((value) => value !== null && (typeof value !== "string" || value.length > 10000))) {
    res.status(400).json({ error: "Fields must be text and no longer than 10,000 characters" });
    return;
  }
  try {
    const columns = [...resource.insertColumns, "workspace_id"];
    const placeholders = columns.map(() => "?").join(", ");
    const [result] = await pool.execute<ResultSetHeader>(
      `INSERT INTO ${resource.table} (${columns.join(", ")}) VALUES (${placeholders})`,
      [...values, req.user!.workspaceId]
    );
    res.status(201).json({ id: result.insertId });
  } catch (error) {
    next(error);
  }
});

router.get("/inbox/conversations", async (req: AuthenticatedRequest, res, next) => {
  try {
    const [rows] = await pool.execute<RowDataPacket[]>(
      `SELECT c.id, c.subject, c.channel, c.status, c.updated_at,
              COALESCE(ct.name, 'New contact') AS contact_name,
              (SELECT m.body FROM messages m WHERE m.conversation_id = c.id
               ORDER BY m.created_at DESC LIMIT 1) AS last_message
       FROM conversations c LEFT JOIN contacts ct ON ct.id = c.contact_id
       WHERE c.workspace_id = ? ORDER BY c.updated_at DESC LIMIT 100`,
      [req.user!.workspaceId]
    );
    res.json({ items: rows });
  } catch (error) {
    next(error);
  }
});
