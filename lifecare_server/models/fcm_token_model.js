const mongoose = require("mongoose");

const fcmToken = new mongoose.Schema({
  deviceId: {
    type: String,
    required: true,
  },
  token: {
    type: String,
    required: true,
  },
});

const token = mongoose.model("fcm_token", fcmToken);

module.exports = {
  token,
};
