var Temperature = require("../models/sensor_value_module").temperature;
var Heartbeat = require("../models/sensor_value_module").heartbeat;

const getTemperatureHistory = (req, res) => {
  Temperature.find()
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

const addTemperature = (req, res) => {
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

const getHeartBeatHistory = (req, res) => {
  Heartbeat.find()
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

const addHeartbeat = (req, res) => {
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

const pushButtonClicked = (req, res) => {
  //add logic for alert send

  const result = {
    message: "push alert send",
  };

  console.log(req.url, " ", req.method, "", result);

  res.json(result);
};

module.exports = {
  addTemperature,
  getTemperatureHistory,
  addHeartbeat,
  getHeartBeatHistory,
  pushButtonClicked,
};
