const router = require("express").Router();

const controller = require("../controller/hospital_controller");

router.get("/hospital", controller.getAllHospital);

router.post("/hospital", controller.addHospital);

router.delete("/hospital/:id", controller.deleteHospital);

module.exports = router;
