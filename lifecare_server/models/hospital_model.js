const mongoose = require("mongoose");

const hospitalSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  location: {
    type: String,
    required: true,
  },
  phone: {
    type: Number,
    required: true,
  },
  pinCode: {
    type: Number,
    required: true,
  },
});

const hospital = mongoose.model("hospital", hospitalSchema);

module.exports = {
  hospital,
};
