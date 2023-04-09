const router = require("express").Router();

const controller = require("../controller/common_controller");

router.post("/fcm", controller.addFCM);

module.exports = router;
