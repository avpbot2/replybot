import type { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";

export interface AuthenticatedRequest extends Request {
  user?: { id: number; workspaceId: number; email: string };
}

export function signToken(payload: { id: number; workspaceId: number; email: string }): string {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret.length < 32) {
    throw new Error("JWT_SECRET must contain at least 32 characters");
  }
  return jwt.sign(payload, secret, { expiresIn: "12h", issuer: "replybot-api" });
}

export function requireAuth(req: AuthenticatedRequest, res: Response, next: NextFunction): void {
  const value = req.header("authorization");
  if (!value?.startsWith("Bearer ")) {
    res.status(401).json({ error: "Authentication required" });
    return;
  }

  const secret = process.env.JWT_SECRET;
  if (!secret || secret.length < 32) {
    next(new Error("JWT_SECRET must contain at least 32 characters"));
    return;
  }

  try {
    const token = jwt.verify(value.slice(7), secret, { issuer: "replybot-api" });
    if (typeof token === "string" || typeof token.id !== "number" ||
        typeof token.workspaceId !== "number" || typeof token.email !== "string") {
      res.status(401).json({ error: "Invalid authentication token" });
      return;
    }
    req.user = { id: token.id, workspaceId: token.workspaceId, email: token.email };
    next();
  } catch {
    res.status(401).json({ error: "Invalid or expired authentication token" });
  }
}
