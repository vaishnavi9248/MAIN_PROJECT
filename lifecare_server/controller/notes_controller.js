const Notes = require("../models/notes_model").note;
const Doc = require("../models/notes_model").doc;

const getAllNotes = (req, res) => {
  Notes.find()
    .select("-__v")
    .then((data) => {
      const result = {
        count: data.length,
        data: data,
      };

      console.log(req.url, " ", req.method, " ", result);
      return res.json(result);
    });
};

const addNote = (req, res) => {
  const { title, description } = req.body;

  if (!title || !description) {
    let errorMap = {};
    if (!title) errorMap.title = "title is required";
    if (!description) errorMap.description = "description is required";

    console.log(req.url, " ", req.method, "", errorMap);

    return res.status(422).json(errorMap);
  }

  const note = new Notes({
    title,
    description,
  });

  note.save().then((data) => {
    const result = {
      message: "Note added successfully",
      data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

const updateNote = (req, res) => {
  const { id, title, description } = req.body;

  if (!id || !title || !description) {
    let errorMap = {};
    if (!id) errorMap.id = "id is required";
    if (!title) errorMap.title = "title is required";
    if (!description) errorMap.description = "description is required";

    console.log(req.url, " ", req.method, "", errorMap);

    return res.status(422).json(errorMap);
  }

  Notes.updateOne({ _id: id }, { title, description }).then((data) => {
    const result = {
      message: "Note Updated successfully",
      data: data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

const deleteNote = (req, res) => {
  const id = req.params.id;

  Notes.deleteOne({ _id: id }).then((data) => {
    const result = {
      message: "Note deleted successfully",
      data: data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

const getAllDocsById = (req, res) => {
  const id = req.params.id;

  Doc.find({ noteId: id })
    .select("-__v")
    .then((data) => {
      const result = {
        count: data.length,
        data: data,
      };

      console.log(req.url, " ", req.method, " ", result);
      return res.json(result);
    });
};

const addDoc = (req, res) => {
  const { noteId, name, url } = req.body;

  if (!noteId || !name || !url) {
    let errorMap = {};
    if (!noteId) errorMap.noteId = "noteId is required";
    if (!name) errorMap.name = "name is required";
    if (!url) errorMap.image = "Image is required";

    console.log(req.url, " ", req.method, "", errorMap);

    return res.status(422).json(errorMap);
  }

  const doc = new Doc({
    noteId,
    name,
    url,
  });

  doc.save().then((data) => {
    const result = {
      message: "Doc added successfully",
      data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

const deleteDoc = (req, res) => {
  const id = req.params.id;

  Doc.deleteOne({ _id: id }).then((data) => {
    const result = {
      message: "Doc deleted successfully",
      data: data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

module.exports = {
  getAllNotes,
  addNote,
  updateNote,
  deleteNote,
  getAllDocsById,
  addDoc,
  deleteDoc,
};
