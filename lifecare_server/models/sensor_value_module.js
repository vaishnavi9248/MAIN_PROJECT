const mongoose = require("mongoose");

const moment = require("moment");

const sensor_value = new mongoose.Schema({
  value: {
    type: Number,
    required: true,
  },

  createdAt: { type: Date, required: true, default: moment().format() },
});

var temperature = mongoose.model("temperature", sensor_value);

var heartbeat = mongoose.model("heartbeat", sensor_value);

module.exports = {
  temperature,
  heartbeat,
};
