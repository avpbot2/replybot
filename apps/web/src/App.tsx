import { useCallback, useEffect, useMemo, useState, type FormEvent, type ReactNode } from "react";
import {
  Alert, AppBar, Avatar, Box, Button, Chip, CircularProgress, Dialog, DialogActions,
  DialogContent, DialogTitle, Divider, Drawer, IconButton, List, ListItemButton,
  ListItemIcon, ListItemText, MenuItem, Paper, Snackbar, Stack, Table, TableBody,
  TableCell, TableHead, TableRow, TextField, Toolbar, Typography, useMediaQuery
} from "@mui/material";
import { useTheme } from "@mui/material/styles";
import {
  AddRounded, AnalyticsRounded, AutoAwesomeRounded, AutoModeRounded, CalendarMonthRounded,
  CampaignRounded, ChatBubbleOutlineRounded, ContactsRounded, DashboardRounded,
  DescriptionRounded, HubRounded, MenuRounded, NotificationsNoneRounded, PersonOutlineRounded,
  SettingsRounded, ShoppingBagRounded, SmartToyRounded, StorefrontRounded
} from "@mui/icons-material";

type User = { id: number; workspaceId: number; email: string; name: string };
type Session = { token: string; user: User };
type Field = { name: string; label: string; required?: boolean; type?: string; options?: string[] };
type Module = {
  id: string;
  label: string;
  icon: ReactNode;
  endpoint?: string;
  fields?: Field[];
  columns?: { key: string; label: string }[];
  description?: string;
};
type Overview = {
  metrics: Record<string, number | string>;
  recentConversations: Array<Record<string, string | number | null>>;
};

const modules: Module[] = [
  { id: "overview", label: "Overview", icon: <DashboardRounded /> },
  { id: "inbox", label: "Team inbox", icon: <ChatBubbleOutlineRounded />, endpoint: "inbox/conversations",
    columns: [{ key: "contact_name", label: "Contact" }, { key: "subject", label: "Conversation" }, { key: "channel", label: "Channel" }, { key: "status", label: "Status" }],
    description: "Shared customer conversations. Provider webhooks and message sending are integration work, not yet connected." },
  { id: "agents", label: "AI agents", icon: <SmartToyRounded />, endpoint: "agents",
    fields: [{ name: "name", label: "Agent name", required: true }, { name: "purpose", label: "Purpose", required: true }, { name: "tone", label: "Tone" }, { name: "status", label: "Status", options: ["draft", "active", "paused"] }],
    columns: [{ key: "name", label: "Agent" }, { key: "purpose", label: "Purpose" }, { key: "tone", label: "Tone" }, { key: "status", label: "Status" }] },
  { id: "knowledge", label: "Knowledge base", icon: <DescriptionRounded />, endpoint: "knowledge",
    fields: [{ name: "title", label: "Document title", required: true }, { name: "source_type", label: "Source type", required: true, options: ["text", "url", "file", "faq"] }, { name: "content", label: "Text content", required: true, type: "multiline" }],
    columns: [{ key: "title", label: "Document" }, { key: "source_type", label: "Source" }, { key: "status", label: "Indexing status" }],
    description: "Text and FAQ records can be stored here. File ingestion, embeddings, vector search and retrieval-augmented generation need an AI/indexing provider." },
  { id: "flows", label: "Automation flows", icon: <AutoModeRounded />, endpoint: "flows",
    fields: [{ name: "name", label: "Flow name", required: true }, { name: "trigger_type", label: "Trigger", required: true }],
    columns: [{ key: "name", label: "Flow" }, { key: "trigger_type", label: "Trigger" }, { key: "status", label: "Status" }] },
  { id: "channels", label: "Channels", icon: <HubRounded />, endpoint: "channels",
    fields: [{ name: "name", label: "Display name", required: true }, { name: "provider", label: "Provider", required: true, options: ["whatsapp", "telegram", "discord", "slack", "website", "indiamart", "tradeindia", "email"] }],
    columns: [{ key: "name", label: "Channel" }, { key: "provider", label: "Provider" }, { key: "status", label: "Status" }],
    description: "Channel records are configurable. Provider authentication, webhook verification, and outbound delivery must be connected before going live." },
  { id: "contacts", label: "Contacts", icon: <ContactsRounded />, endpoint: "contacts",
    fields: [{ name: "name", label: "Contact name", required: true }, { name: "email", label: "Email address", type: "email" }, { name: "phone", label: "Phone number" }],
    columns: [{ key: "name", label: "Name" }, { key: "email", label: "Email" }, { key: "phone", label: "Phone" }, { key: "source", label: "Source" }] },
  { id: "leads", label: "Leads", icon: <PersonOutlineRounded />, endpoint: "leads",
    fields: [{ name: "name", label: "Lead name", required: true }, { name: "email", label: "Email address", type: "email" }, { name: "phone", label: "Phone number" }, { name: "source", label: "Lead source" }],
    columns: [{ key: "name", label: "Lead" }, { key: "email", label: "Email" }, { key: "source", label: "Source" }, { key: "status", label: "Stage" }] },
  { id: "bookings", label: "Bookings", icon: <CalendarMonthRounded />, endpoint: "bookings",
    fields: [{ name: "customer_name", label: "Customer name", required: true }, { name: "service", label: "Service", required: true }, { name: "starts_at", label: "Start time", required: true, type: "datetime-local" }],
    columns: [{ key: "customer_name", label: "Customer" }, { key: "service", label: "Service" }, { key: "starts_at", label: "Start time" }, { key: "status", label: "Status" }] },
  { id: "orders", label: "Orders", icon: <ShoppingBagRounded />, endpoint: "orders",
    fields: [{ name: "order_reference", label: "Order reference", required: true }, { name: "amount", label: "Amount", type: "number" }, { name: "currency", label: "Currency", required: true }],
    columns: [{ key: "order_reference", label: "Order" }, { key: "amount", label: "Amount" }, { key: "currency", label: "Currency" }, { key: "status", label: "Status" }] },
  { id: "templates", label: "Templates", icon: <DescriptionRounded />, endpoint: "templates",
    fields: [{ name: "name", label: "Template name", required: true }, { name: "channel", label: "Channel", required: true }, { name: "body", label: "Message", required: true, type: "multiline" }],
    columns: [{ key: "name", label: "Template" }, { key: "channel", label: "Channel" }, { key: "status", label: "Approval" }] },
  { id: "campaigns", label: "Campaigns", icon: <CampaignRounded />, endpoint: "campaigns",
    fields: [{ name: "name", label: "Campaign name", required: true }, { name: "channel", label: "Channel", required: true }, { name: "scheduled_at", label: "Schedule time", type: "datetime-local" }],
    columns: [{ key: "name", label: "Campaign" }, { key: "channel", label: "Channel" }, { key: "scheduled_at", label: "Scheduled" }, { key: "status", label: "Status" }],
    description: "Campaign metadata and schedules can be saved. Message-template approval, consent enforcement and provider delivery are not yet connected." },
  { id: "analytics", label: "Analytics", icon: <AnalyticsRounded />, description: "Workspace overview metrics are available from the dashboard. Event-based conversion, model-cost and channel analytics need provider event ingestion." },
  { id: "settings", label: "Settings & security", icon: <SettingsRounded />, description: "Workspace membership, access roles, secret storage, retention rules and audit trails belong here. Production-grade administration is not yet implemented." }
];

const metricLabels: Record<string, { label: string; icon: ReactNode; color: string }> = {
  open_conversations: { label: "Open conversations", icon: <ChatBubbleOutlineRounded />, color: "#3458d4" },
  active_leads: { label: "Active leads", icon: <ContactsRounded />, color: "#e59435" },
  active_agents: { label: "Active AI agents", icon: <AutoAwesomeRounded />, color: "#18a689" },
  upcoming_bookings: { label: "Upcoming bookings", icon: <CalendarMonthRounded />, color: "#8b62cb" }
};

async function request<T>(path: string, token: string, init?: RequestInit): Promise<T> {
  const response = await fetch(`/api/${path}`, {
    ...init,
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
      ...init?.headers
    }
  });
  const body = await response.json() as T & { error?: string };
  if (!response.ok) throw new Error(body.error ?? `Request failed with status ${response.status}`);
  return body;
}

function AuthScreen({ onLogin }: { onLogin: (session: Session) => void }) {
  const [registering, setRegistering] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [form, setForm] = useState({ name: "", workspaceName: "", email: "", password: "" });

  async function submit(event: FormEvent) {
    event.preventDefault();
    setBusy(true);
    setError("");
    try {
      const endpoint = registering ? "auth/register" : "auth/login";
      const result = await request<Session>(endpoint, "", {
        method: "POST",
        body: JSON.stringify(form)
      });
      onLogin(result);
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "Unable to sign in");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Box className="auth-page">
      <Paper className="auth-card" elevation={0}>
        <Stack spacing={3}>
          <Stack direction="row" spacing={1.5} alignItems="center">
            <Avatar sx={{ bgcolor: "primary.main", borderRadius: 2 }}><AutoAwesomeRounded /></Avatar>
            <Typography variant="h5">replybot</Typography>
          </Stack>
          <Box>
            <Typography variant="h4" sx={{ mb: 1 }}>{registering ? "Create your workspace" : "Welcome back"}</Typography>
            <Typography color="text.secondary">Bring every customer conversation into one place.</Typography>
          </Box>
          {error && <Alert severity="error">{error}</Alert>}
          <Box component="form" onSubmit={submit}>
            <Stack spacing={2}>
              {registering && <>
                <TextField label="Your name" required autoComplete="name" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
                <TextField label="Workspace name" required value={form.workspaceName} onChange={(e) => setForm({ ...form, workspaceName: e.target.value })} />
              </>}
              <TextField label="Email" type="email" required autoComplete="email" value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} />
              <TextField label="Password" type="password" required autoComplete={registering ? "new-password" : "current-password"} inputProps={{ minLength: registering ? 10 : undefined }} value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} />
              <Button type="submit" variant="contained" size="large" disabled={busy}>
                {busy ? <CircularProgress size={22} color="inherit" /> : registering ? "Create account" : "Sign in"}
              </Button>
            </Stack>
          </Box>
          <Button onClick={() => { setRegistering(!registering); setError(""); }} color="inherit">
            {registering ? "Already have an account? Sign in" : "New to Replybot? Create a workspace"}
          </Button>
        </Stack>
      </Paper>
    </Box>
  );
}

function App() {
  const theme = useTheme();
  const desktop = useMediaQuery(theme.breakpoints.up("md"));
  const [session, setSession] = useState<Session | null>(() => {
    const stored = localStorage.getItem("replybot-session");
    return stored ? JSON.parse(stored) as Session : null;
  });
  const [activeId, setActiveId] = useState("overview");
  const [overview, setOverview] = useState<Overview | null>(null);
  const [items, setItems] = useState<Array<Record<string, unknown>>>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [mobileOpen, setMobileOpen] = useState(false);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [draft, setDraft] = useState<Record<string, string>>({});

  const activeModule = useMemo(() => modules.find((module) => module.id === activeId)!, [activeId]);
  const loadData = useCallback(async () => {
    if (!session) return;
    setLoading(true);
    setError("");
    try {
      if (activeId === "overview" || activeId === "analytics") {
        const result = await request<Overview>("overview", session.token);
        setOverview(result);
        setItems([]);
      } else if (activeModule.endpoint) {
        const result = await request<{ items: Array<Record<string, unknown>> }>(
          activeModule.endpoint, session.token
        );
        setItems(result.items);
      } else {
        setItems([]);
      }
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "Unable to load data");
    } finally {
      setLoading(false);
    }
  }, [activeId, activeModule, session]);

  useEffect(() => { void loadData(); }, [loadData]);

  function handleLogin(value: Session) {
    localStorage.setItem("replybot-session", JSON.stringify(value));
    setSession(value);
  }

  function handleLogout() {
    localStorage.removeItem("replybot-session");
    setSession(null);
  }

  async function createItem(event: FormEvent) {
    event.preventDefault();
    if (!session || !activeModule.endpoint) return;
    try {
      await request(activeModule.endpoint, session.token, {
        method: "POST",
        body: JSON.stringify(draft)
      });
      setDialogOpen(false);
      setDraft({});
      setSuccess(`${activeModule.label.replace(/s$/, "")} created`);
      await loadData();
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "Unable to save record");
    }
  }

  function selectModule(id: string) {
    setActiveId(id);
    setMobileOpen(false);
  }

  if (!session) return <AuthScreen onLogin={handleLogin} />;

  const sidebar = (
    <Box className="sidebar">
      <Stack direction="row" spacing={1.5} alignItems="center" sx={{ px: 2.5, py: 2.5 }}>
        <Avatar sx={{ bgcolor: "primary.main", width: 36, height: 36, borderRadius: 2 }}><AutoAwesomeRounded fontSize="small" /></Avatar>
        <Typography variant="h6" sx={{ letterSpacing: "-.04em" }}>replybot</Typography>
      </Stack>
      <Paper variant="outlined" sx={{ mx: 2, p: 1.3, bgcolor: "#fbfcff", borderColor: "divider" }}>
        <Typography variant="caption" color="text.secondary">WORKSPACE</Typography>
        <Typography variant="body2" fontWeight={650} className="workspace-chip">{session.user.name}'s workspace</Typography>
      </Paper>
      <List sx={{ px: 1.3, py: 2, flex: 1 }}>
        {modules.map((module, index) => (
          <React.Fragment key={module.id}>
            {(index === 1 || index === 5 || index === 9 || index === 11) && index !== 1 && <Divider sx={{ my: 1.2 }} />}
            <ListItemButton selected={activeId === module.id} onClick={() => selectModule(module.id)}
              sx={{ borderRadius: 2, mb: 0.4, minHeight: 42 }}>
              <ListItemIcon sx={{ minWidth: 38, color: activeId === module.id ? "primary.main" : "text.secondary" }}>{module.icon}</ListItemIcon>
              <ListItemText primary={module.label} primaryTypographyProps={{ fontSize: 13.5, fontWeight: activeId === module.id ? 650 : 500 }} />
            </ListItemButton>
          </React.Fragment>
        ))}
      </List>
      <Box sx={{ px: 2, pb: 2 }}>
        <Divider sx={{ mb: 1.5 }} />
        <Stack direction="row" spacing={1.2} alignItems="center">
          <Avatar sx={{ width: 34, height: 34, bgcolor: "#e8edff", color: "primary.dark", fontSize: 13 }}>{session.user.name.slice(0, 1).toUpperCase()}</Avatar>
          <Box sx={{ minWidth: 0, flex: 1 }}>
            <Typography variant="body2" fontWeight={650} noWrap>{session.user.name}</Typography>
            <Typography variant="caption" color="text.secondary" noWrap>{session.user.email}</Typography>
          </Box>
          <Button size="small" onClick={handleLogout}>Exit</Button>
        </Stack>
      </Box>
    </Box>
  );

  return (
    <Box className="app-shell">
      {desktop ? sidebar : <Drawer open={mobileOpen} onClose={() => setMobileOpen(false)}>{sidebar}</Drawer>}
      <Box sx={{ flex: 1, minWidth: 0 }}>
        <AppBar position="sticky" color="inherit" elevation={0} sx={{ borderBottom: "1px solid", borderColor: "divider" }}>
          <Toolbar sx={{ minHeight: "64px !important", px: { xs: 2, md: 4 }, gap: 1 }}>
            {!desktop && <IconButton onClick={() => setMobileOpen(true)} aria-label="Open navigation"><MenuRounded /></IconButton>}
            <Typography variant="body2" color="text.secondary" sx={{ flex: 1 }}>{activeModule.label}</Typography>
            <IconButton aria-label="Notifications"><NotificationsNoneRounded /></IconButton>
            {activeModule.fields && <Button variant="contained" startIcon={<AddRounded />} onClick={() => setDialogOpen(true)} sx={{ ml: 1 }}>
              Add {activeModule.label.replace(/s$/, "")}
            </Button>}
          </Toolbar>
        </AppBar>

        <Box component="main" className="main-content">
          <Stack direction={{ xs: "column", sm: "row" }} justifyContent="space-between" alignItems={{ xs: "flex-start", sm: "center" }} sx={{ mb: 3 }}>
            <Box>
              <Typography variant="h4">{activeId === "overview" ? "Good morning" : activeModule.label}</Typography>
              <Typography color="text.secondary" sx={{ mt: 0.6 }}>
                {activeId === "overview" ? "Here’s what’s happening across your workspace." : activeModule.description ?? `Manage ${activeModule.label.toLowerCase()} for your workspace.`}
              </Typography>
            </Box>
            {activeId === "overview" && <Button variant="outlined" startIcon={<StorefrontRounded />} onClick={() => selectModule("channels")} sx={{ mt: { xs: 2, sm: 0 } }}>Connect a channel</Button>}
          </Stack>

          {error && <Alert severity="error" sx={{ mb: 2 }} onClose={() => setError("")}>{error}</Alert>}
          {loading && <Box sx={{ py: 6, textAlign: "center" }}><CircularProgress /></Box>}

          {!loading && (activeId === "overview" || activeId === "analytics") && overview && (
            <>
              <Box className="metric-grid">
                {Object.entries(metricLabels).map(([key, meta]) => (
                  <Paper key={key} variant="outlined" sx={{ p: 2.2, borderColor: "divider" }}>
                    <Stack direction="row" justifyContent="space-between" alignItems="center">
                      <Typography variant="body2" color="text.secondary">{meta.label}</Typography>
                      <Avatar variant="rounded" sx={{ width: 36, height: 36, bgcolor: `${meta.color}14`, color: meta.color }}>{meta.icon}</Avatar>
                    </Stack>
                    <Typography variant="h4" sx={{ mt: 2 }}>{Number(overview.metrics[key] ?? 0).toLocaleString()}</Typography>
                  </Paper>
                ))}
              </Box>
              <Box className="content-grid">
                <Paper variant="outlined" sx={{ overflow: "hidden", borderColor: "divider" }}>
                  <Stack direction="row" justifyContent="space-between" alignItems="center" sx={{ p: 2.2 }}>
                    <Box><Typography variant="h6">Recent conversations</Typography><Typography variant="body2" color="text.secondary">Latest customer activity</Typography></Box>
                    <Button onClick={() => selectModule("inbox")}>Open inbox</Button>
                  </Stack>
                  <Divider />
                  {overview.recentConversations.length ? <Table size="small">
                    <TableHead><TableRow><TableCell>Contact</TableCell><TableCell>Conversation</TableCell><TableCell>Channel</TableCell><TableCell>Status</TableCell></TableRow></TableHead>
                    <TableBody>{overview.recentConversations.map((row) => <TableRow key={row.id}>
                      <TableCell>{row.contact_name}</TableCell><TableCell>{row.subject}</TableCell><TableCell>{row.channel}</TableCell><TableCell><StatusChip value={row.status} /></TableCell>
                    </TableRow>)}</TableBody>
                  </Table> : <EmptyState label="No conversations yet" />}
                </Paper>
                <Paper variant="outlined" sx={{ p: 2.2, borderColor: "divider" }}>
                  <Typography variant="h6">Get started</Typography>
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5, mb: 2 }}>Set up the essentials for your AI workspace.</Typography>
                  <Stack spacing={1}>
                    <QuickAction icon={<SmartToyRounded />} title="Create your first agent" onClick={() => selectModule("agents")} />
                    <QuickAction icon={<DescriptionRounded />} title="Add business knowledge" onClick={() => selectModule("knowledge")} />
                    <QuickAction icon={<HubRounded />} title="Connect a messaging channel" onClick={() => selectModule("channels")} />
                  </Stack>
                </Paper>
              </Box>
            </>
          )}

          {!loading && activeId !== "overview" && activeId !== "analytics" && activeId !== "settings" && (
            <Paper variant="outlined" sx={{ overflow: "hidden", borderColor: "divider" }}>
              <Stack direction="row" justifyContent="space-between" alignItems="center" sx={{ p: 2.2 }}>
                <Box><Typography variant="h6">{activeModule.label}</Typography><Typography variant="body2" color="text.secondary">{items.length} records</Typography></Box>
                {activeModule.fields && <Button variant="contained" startIcon={<AddRounded />} onClick={() => setDialogOpen(true)}>Add new</Button>}
              </Stack>
              <Divider />
              {items.length && activeModule.columns ? <Table>
                <TableHead><TableRow>{activeModule.columns.map((column) => <TableCell key={column.key}>{column.label}</TableCell>)}</TableRow></TableHead>
                <TableBody>{items.map((row, index) => <TableRow key={String(row.id ?? index)} hover>
                  {activeModule.columns!.map((column) => <TableCell key={column.key}>
                    {column.key === "status" ? <StatusChip value={row[column.key]} /> : displayValue(row[column.key])}
                  </TableCell>)}
                </TableRow>)}</TableBody>
              </Table> : <EmptyState label={`No ${activeModule.label.toLowerCase()} yet`} />}
            </Paper>
          )}
          {!loading && (activeId === "analytics" || activeId === "settings") && (
            <Paper variant="outlined" sx={{ p: 3, borderColor: "divider" }}>
              <Typography variant="h6">{activeId === "analytics" ? "Workspace snapshot" : "Workspace access"}</Typography>
              <Typography color="text.secondary" sx={{ mt: 1 }}>
                {activeId === "analytics"
                  ? "The cards above show live database counts. More detailed conversion, response-time and AI cost reporting depends on capturing provider and model events."
                  : "You are signed in to this workspace as its creator. Invite flows, role management, secret rotation and retention controls need to be configured before production use."}
              </Typography>
              {activeId === "analytics" && overview && <Stack direction="row" spacing={1} sx={{ mt: 2 }}>{Object.entries(metricLabels).map(([key, meta]) => <Chip key={key} label={`${meta.label}: ${Number(overview.metrics[key] ?? 0)}`} />)}</Stack>}
            </Paper>
          )}
        </Box>
      </Box>

      <Dialog open={dialogOpen} onClose={() => setDialogOpen(false)} fullWidth maxWidth="sm">
        <Box component="form" onSubmit={createItem}>
          <DialogTitle>Add {activeModule.label.replace(/s$/, "").toLowerCase()}</DialogTitle>
          <DialogContent><Stack spacing={2} sx={{ pt: 1 }}>
            {activeModule.fields?.map((field) => field.options
              ? <TextField key={field.name} select label={field.label} required={field.required} value={draft[field.name] ?? ""} onChange={(event) => setDraft({ ...draft, [field.name]: event.target.value })}>
                  {field.options.map((option) => <MenuItem key={option} value={option}>{option}</MenuItem>)}
                </TextField>
              : <TextField key={field.name} label={field.label} type={field.type === "multiline" ? undefined : field.type ?? "text"} required={field.required} multiline={field.type === "multiline"} minRows={field.type === "multiline" ? 4 : undefined} InputLabelProps={field.type === "datetime-local" ? { shrink: true } : undefined} value={draft[field.name] ?? ""} onChange={(event) => setDraft({ ...draft, [field.name]: event.target.value })} />)}
          </Stack></DialogContent>
          <DialogActions sx={{ px: 3, pb: 2.5 }}>
            <Button color="inherit" onClick={() => setDialogOpen(false)}>Cancel</Button>
            <Button type="submit" variant="contained">Save</Button>
          </DialogActions>
        </Box>
      </Dialog>
      <Snackbar open={Boolean(success)} autoHideDuration={3000} onClose={() => setSuccess("")}><Alert severity="success" onClose={() => setSuccess("")}>{success}</Alert></Snackbar>
    </Box>
  );
}

function StatusChip({ value }: { value: unknown }) {
  const label = String(value ?? "unknown");
  const color = ["active", "connected", "confirmed", "approved", "won", "ready"].includes(label)
    ? "success" : ["open", "new", "queued", "scheduled", "requested", "pending"].includes(label) ? "warning" : "default";
  return <Chip size="small" label={label.replaceAll("_", " ")} color={color} variant={color === "default" ? "outlined" : "filled"} />;
}

function displayValue(value: unknown): string {
  if (value === null || value === undefined || value === "") return "—";
  const text = String(value);
  return text.length > 70 ? `${text.slice(0, 67)}...` : text;
}

function EmptyState({ label }: { label: string }) {
  return <Stack alignItems="center" spacing={1} sx={{ p: 6, textAlign: "center" }}>
    <Avatar sx={{ bgcolor: "#f0f3fa", color: "text.secondary" }}><ChatBubbleOutlineRounded /></Avatar>
    <Typography fontWeight={650}>{label}</Typography>
    <Typography variant="body2" color="text.secondary">Records you add to this workspace will appear here.</Typography>
  </Stack>;
}

function QuickAction({ icon, title, onClick }: { icon: ReactNode; title: string; onClick: () => void }) {
  return <Button variant="outlined" color="inherit" onClick={onClick} startIcon={icon} sx={{ justifyContent: "flex-start", borderColor: "divider", py: 1.2, color: "text.primary" }}>{title}</Button>;
}

export default App;
