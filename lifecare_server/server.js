const bodyParser = require("body-parser");
const express = require("express");
const app = express();

const http = require("http").createServer(app);
const io = require("socket.io")(http);

const key = require("./key");

const admin = require("firebase-admin");

const serviceAccount = require("./firebase-adminSdk.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

//mongodb connection
require("./data/services/database_service");

app.use(express.json());

app.use(express.static("uploads"));
app.use(bodyParser.urlencoded({ extended: true }));

//set io to req.io for access from all routes
//set server ip to access from every where
app.use((req, res, next) => {
  req.io = io;
  req.serverIp = key.SERVER_URL;
  req.admin = admin;
  return next();
});

//api routes
app.use(require("./routes/system_route"));
app.use(require("./routes/common_route"));
app.use(require("./routes/hospital_route"));
app.use(require("./routes/contact_route"));
app.use(require("./routes/notes_route"));

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

//socket connection
io.on("connection", (socket) => {
  console.log(`on connect`);

  socket.on("connect_error", (err) =>
    console.log(`connect_error due to ${err.message}`)
  );

  socket.on("disconnect", () => {
    console.log(`on disconnect`);
  });
});

http.listen(5678, () => console.log("server running..."));
