const bodyParser = require("body-parser");
const express = require("express");
const app = express();

const http = require("http").createServer(app);
const io = require("socket.io")(http);

const key = require("./key");

//mongodb connection
require("./data/services/database_service");

//mongoose schema
require("./models/sensor_value_module");

app.use(express.json());

app.use(express.static("uploads"));
app.use(bodyParser.urlencoded({ extended: true }));

//set io to req.io for access from all routes
//set server ip to access from every where
app.use((req, res, next) => {
  req.io = io;
  req.serverIp = key.SERVER_URL;
  return next();
});

//api routes
app.use(require("./routes/system_route"));
app.use(require("./routes/common_route"));
app.use(require("./routes/hospital_route"));
app.use(require("./routes/contact_route"));

//invalid api
app.get("*", (req, res) => {
  console.log("invalid request ", req.method, " ", req.url, req.headers);
  res.status(401).json({ error: "Invalid Request" });
});

app.post("*", (req, res) => {
  console.log("invalid request ", req.method, " ", req.url, req.headers);
  res.status(401).json({ error: "Invalid Request" });
});

app.delete("*", (req, res) => {
  console.log("invalid request ", req.method, " ", req.url, req.headers);
  res.status(401).json({ error: "Invalid Request" });
});

app.put("*", (req, res) => {
  console.log("invalid request ", req.method, " ", req.url, req.headers);
  res.status(401).json({ error: "Invalid Request" });
});

//socket middleware
// io.use(require("./middleware/socket_auth"));

//socket connection
io.on("connection", (socket) => {
  //update user status and socket id
  // userController.onUserConnect(socket, io);

  socket.on("connect_error", (err) =>
    console.log(`connect_error due to ${err.message}`)
  );

  socket.on("disconnect", () => {
    //update last seen, status, socketId
    // userController.disconnectUser(socket, io);
  });

  //socket connection
});

http.listen(5678, () => console.log("server running..."));
