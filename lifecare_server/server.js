const express = require("express");
const app = express();

const http = require("http").createServer(app);

app.get("*", (req, res) => {
  var result = {
    message: "Success",
  };

  console.log(result, req.method, " ", req.url);
  res.json(result);
});

http.listen(1124, () => console.log("server running..."));
