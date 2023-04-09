const router = require("express").Router();

const controller = require("../controller/system_controller");

router.get("/temperature", controller.getTemperatureHistory);

router.post("/temperature", controller.addTemperature);

router.get("/heartbeat", controller.getHeartBeatHistory);

router.post("/heartbeat", controller.addHeartbeat);

router.get("/pushButton", controller.pushButtonClicked);

module.exports = router;
