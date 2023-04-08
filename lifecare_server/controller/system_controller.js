const mongoose = require("mongoose");

var Temperature = require("../models/sensor_value_module").temperature;
var Heartbeat = require("../models/sensor_value_module").heartbeat;

const temperatureValue = (req, res) => {
  const { value } = req.body;

  if (!value) {
    let errorMap = { value: "value is required" };

    console.log(req.url, " ", req.method, "", errorMap);
    return res.status(422).json(errorMap);
  }

  const temp = new Temperature({
    value: value,
  });

  temp.save().then((temp) => {
    const result = {
      message: "value added",
      data: temp,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

const heartbeatValue = (req, res) => {
  const { value } = req.body;

  if (!value) {
    let errorMap = { value: "value is required" };

    console.log(req.url, " ", req.method, "", errorMap);
    return res.status(422).json(errorMap);
  }

  const heart = new Heartbeat({
    value: value,
  });

  heart.save().then((heart) => {
    const result = {
      message: "value added",

      data: heart,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

module.exports = {
  temperatureValue,
  heartbeatValue,
};
