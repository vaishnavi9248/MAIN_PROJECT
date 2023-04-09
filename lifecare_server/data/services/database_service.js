const mongoose = require("mongoose");
const key = require("../../key");

// mongoose connection
mongoose.connect(key.MONGO_URL, {
  useNewUrlParser: true,
  dbName: 'test_db',
});

mongoose.connection.on("connected", () => console.log("Connected to mongodb"));

mongoose.connection.on("disconnected", () =>
  console.log("Disconnected to mongodb")
);

mongoose.connection.on("error", (err) =>
  console.log("Error on connection ", err)
);

module.exports = {
  mongoose,
};