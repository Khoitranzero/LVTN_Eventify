import express from "express";
import { Server } from "ws";
import http from "http";
import configViewEngine from "./config/viewEngine";
import bodyParser from "body-parser";
import initAppApiRoutes from "./routes/appApi";
import initWebApiRoutes from "./routes/webApi";
import configCors from "./config/cors";
// import cookieParse from 'cookie-parser';
require("dotenv").config();
const app = express();
const PORT = process.env.PORT || 8080;

configCors(app);
configViewEngine(app);
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

//config cookie parser
// app.use(cookieParse());
initWebApiRoutes(app);
initAppApiRoutes(app);
app.use((req, res) => {
  return res.send("404 not found");
});

// Create an HTTP server
const server = http.createServer(app);

// Initialize WebSocket server
const wss = new Server({ server });

let clients = []; // Mảng chứa các kết nối WebSocket hiện tại.

wss.on("connection", (ws) => {
  clients.push(ws);
  console.log("Client connected");// Lắng nghe sự kiện kết nối từ client.

  ws.on("message", (message) => {
    console.log("Received:", message);// Lắng nghe sự kiện khi nhận được tin nhắn từ client.
  });

  ws.on("close", () => {
    clients = clients.filter((client) => client !== ws);
    console.log("Client disconnected"); // Lắng nghe sự kiện khi client ngắt kết nối.
  });
});

const broadcast = (data) => {
  clients.forEach((client) => {
    if (client.readyState === client.OPEN) {
      client.send(JSON.stringify(data));
    }
  });
}; // Hàm gửi dữ liệu đến tất cả các client đang kết nối.

server.listen(PORT, () => {
  console.log("server backend port = " + PORT);
});

export { broadcast };
