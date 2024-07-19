const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

app.use(bodyParser.json());

// Connect to MongoDB
mongoose.connect("mongodb://localhost:27017/chat", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const MessageSchema = new mongoose.Schema({
  senderId: String,
  text: String,
  timestamp: Date,
});

const Message = mongoose.model("Message", MessageSchema);

// API endpoint to get messages
app.get("/messages", async (req, res) => {
  const messages = await Message.find().sort("timestamp");
  res.send(messages);
});

// WebSocket connection
io.on("connection", (socket) => {
  console.log("New client connected");

  socket.on("sendMessage", async (data) => {
    const message = new Message({
      senderId: data.senderId,
      text: data.text,
      timestamp: new Date(),
    });

    await message.save();
    io.emit("receiveMessage", message);
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected");
  });
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on port ${PORT}`));

// API endpoint to send a message
app.post("/sendMessage", async (req, res) => {
  const { senderId, text, timestamp, profilePicUrl } = req.body;
  const message = new Message({
    senderId,
    text,
    timestamp: new Date(timestamp),
    profilePicUrl,
  });

  await message.save();
  io.emit("receiveMessage", message);
  res.send({ status: "Message sent" });
});
