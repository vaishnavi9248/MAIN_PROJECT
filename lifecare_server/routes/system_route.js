const router = require("express").Router();

const controller = require("../controller/system_controller");

router.post("/temperature", controller.temperatureValue);

router.post("/heartbeat", controller.heartbeatValue);

module.exports = router;
