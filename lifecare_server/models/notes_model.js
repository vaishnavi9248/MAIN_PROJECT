const mongoose = require("mongoose");

const noteSchema = new mongoose.Schema({
  title: {
    type: String,
    default: "",
  },
  description: {
    type: String,
    default: "",
  },
});

const docSchema = new mongoose.Schema({
  noteId: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  url: {
    type: String,
    required: true,
  },
});

const note = mongoose.model("note", noteSchema);
const doc = mongoose.model("doc", docSchema);

module.exports = {
  note,
  doc,
};
