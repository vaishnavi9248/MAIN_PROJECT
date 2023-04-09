const router = require("express").Router();

const controller = require("../controller/notes_controller");

router.get("/notes", controller.getAllNotes);

router.post("/notes", controller.addNote);

router.put("/notes", controller.updateNote);

router.delete("/notes/:id", controller.deleteNote);

router.get("/doc/:id", controller.getAllDocsById);

router.post("/doc", controller.addDoc);

router.delete("/doc/:id", controller.deleteDoc);

module.exports = router;
