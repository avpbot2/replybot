import "dotenv/config";
import express, { type ErrorRequestHandler } from "express";
import cors from "cors";
import helmet from "helmet";
import { router } from "./routes.js";

if (!process.env.JWT_SECRET || process.env.JWT_SECRET.length < 32) {
  throw new Error("JWT_SECRET must be configured with at least 32 characters");
}

const app = express();
app.use(helmet());
app.use(cors({ origin: process.env.WEB_ORIGIN ?? "http://localhost:5173" }));
app.use(express.json({ limit: "1mb" }));
app.use("/api", router);
app.use((_req, res) => res.status(404).json({ error: "Route not found" }));

const errors: ErrorRequestHandler = (error, _req, res, _next) => {
  console.error("Request failed", error);
  res.status(500).json({ error: "An unexpected server error occurred" });
};
app.use(errors);

const port = Number(process.env.PORT ?? 4000);
app.listen(port, () => {
  console.log(`Replybot API listening on port ${port}`);
});
