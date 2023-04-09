const router = require("express").Router();

const controller = require("../controller/contact_controller");

router.get("/contact", controller.getAllContact);

router.post("/contact", controller.addContact);

router.delete("/contact/:id", controller.deleteContact);

module.exports = router;
