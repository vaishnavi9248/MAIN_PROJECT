const mongoose = require("mongoose");

const moment = require("moment");

const sensorValue = new mongoose.Schema({
  value: {
    type: Number,
    required: true,
  },

  createdAt: { type: Date, required: true, default: Date.now },
});

const temperature = mongoose.model("temperature", sensorValue);

const heartbeat = mongoose.model("heartbeat", sensorValue);

module.exports = {
  temperature,
  heartbeat,
};
