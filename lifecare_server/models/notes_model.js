const mongoose = require("mongoose");

const noteSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
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
