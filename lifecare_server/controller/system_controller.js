const moment = require("moment");

const Temperature = require("../models/sensor_value_module").temperature;
const Heartbeat = require("../models/sensor_value_module").heartbeat;
const FCMToken = require("../models/fcm_token_model").token;

const getTemperatureHistory = (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;

  Temperature.find()
    .skip((page - 1) * limit)
    .limit(limit)
    .select("-__v")
    .sort({ createdAt: "desc" })
    .then((data) => {
      const currentCount = data.length;
      Temperature.countDocuments().then((totalCount) => {
        const totalPages = Math.ceil(totalCount / limit);
        const result = {
          currentCount,
          totalCount,
          totalPages,
          data,
        };

        console.log(req.url, " ", req.method, " ", result);
        return res.json(result);
      });
    });
};

const addTemperature = (req, res) => {
  const { value } = req.body;

  if (!value) {
    let errorMap = { value: "value is required" };

    console.log(req.url, " ", req.method, "", errorMap);
    return res.status(422).json(errorMap);
  }

  const start = new Date();
  const end = moment().subtract(1, "minute").toDate();

  const newTemperature = new Temperature({ value: value, createdAt: start });
  newTemperature.save().then((NewData) => {
    Temperature.aggregate([
      {
        $match: {
          createdAt: {
            $gte: end,
            $lte: start,
          },
        },
      },
      {
        $group: {
          _id: null,
          averageValue: { $avg: "$value" },
          count: { $sum: 1 },
        },
      },
    ])
      .then((result) => {
        if (result && result.length > 0) {
          const io = req.io;
          const average = parseFloat(result[0].averageValue.toFixed(2));

          if (average > 99) {
            const data = {
              message: "High heat count",
              data: NewData,
              average,
            };

            console.log(req.url, " ", req.method, " ", data);

            io.emit("newTemperature", data);

            const message = {
              notification: {
                title: "Temperature warning!!!",
                body: data.message,
              },
            };

            sendFCMToDevices(message, req, res);

            return res.json(data);
          } else if (average < 97) {
            const data = {
              message: "Low heat count",
              data: NewData,
              average,
            };

            console.log(req.url, " ", req.method, " ", data);

            io.emit("newTemperature", data);

            const message = {
              notification: {
                title: "Temperature warning!!!",
                body: data.message,
              },
            };

            sendFCMToDevices(message, req, res);

            return res.json(data);
          } else {
            const data = {
              message: "New temperature saved successfully!",
              data: NewData,
              averageValue: average,
            };

            console.log(req.url, " ", req.method, " ", data);

            io.emit("newTemperature", data);

            return res.json(data);
          }
        }
        return res.json({ message: "Something wrong", result });
      })
      .catch((err) => {
        console.log("err", err);
      });
  });
};

const getHeartBeatHistory = (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;

  Heartbeat.find()
    .skip((page - 1) * limit)
    .limit(limit)
    .select("-__v")
    .sort({ createdAt: "desc" })
    .then((data) => {
      const currentCount = data.length;
      Heartbeat.countDocuments().then((totalCount) => {
        const totalPages = Math.ceil(totalCount / limit);
        const result = {
          currentCount,
          totalCount,
          totalPages,
          data,
        };

        console.log(req.url, " ", req.method, " ", result);
        return res.json(result);
      });
    });
};

const addHeartbeat = (req, res) => {
  const { value } = req.body;

  if (!value) {
    let errorMap = { value: "value is required" };

    console.log(req.url, " ", req.method, "", errorMap);
    return res.status(422).json(errorMap);
  }

  const start = new Date();
  const end = moment().subtract(1, "minute").toDate();

  const newHeartbeat = Heartbeat({ value: value, createdAt: start });
  newHeartbeat.save().then((NewData) => {
    Heartbeat.aggregate([
      {
        $match: {
          createdAt: {
            $gte: end,
            $lte: start,
          },
        },
      },
      {
        $group: {
          _id: null,
          averageValue: { $avg: "$value" },
          count: { $sum: 1 },
        },
      },
    ])
      .then((result) => {
        if (result && result.length > 0) {
          const io = req.io;
          const average = parseFloat(result[0].averageValue.toFixed(2));

          if (average > 100) {
            const data = {
              message: "High heartbeat count",
              data: NewData,
              average,
            };

            console.log(req.url, " ", req.method, " ", data);

            io.emit("newHeartBeat", data);

            const message = {
              notification: {
                title: "Heartbeat warning!!!",
                body: data.message,
              },
            };

            sendFCMToDevices(message, req, res);

            return res.json(data);
          } else if (average < 60) {
            const data = {
              message: "Low heartbeat count",
              data: NewData,
              average,
            };

            console.log(req.url, " ", req.method, " ", data);

            io.emit("newHeartBeat", data);

            const message = {
              notification: {
                title: "Heartbeat warning!!!",
                body: data.message,
              },
            };

            sendFCMToDevices(message, req, res);

            return res.json(data);
          } else {
            const data = {
              message: "New heartbeat saved successfully!",
              data: NewData,
              average,
            };

            console.log(req.url, " ", req.method, " ", data);

            io.emit("newHeartBeat", data);

            return res.json(data);
          }
        }
        return res.json({ message: "Something wrong", result });
      })
      .catch((err) => {
        console.log("err", err);
      });
  });
};
const pushButtonClicked = (req, res) => {
  const message = {
    notification: {
      title: "Hello, World!",
      body: "This is a notification from my server!",
    },
  };

  sendFCMToDevices(message, req, res);

  const result = {
    message: "Push sent",
  };

  return res.json(result);
};

sendFCMToDevices = (message, req) => {
  const tokens = [];

  FCMToken.find()
    .then((data) => {
      data.forEach((item) => {
        tokens.push(item.token);
      });

      message.tokens = tokens;

      req.admin
        .messaging()
        .sendMulticast(message)
        .then((response) => {
          const result = {
            message: "Push alert sent successfully",
            successCount: response.successCount,
            failureCount: response.failureCount,
          };

          console.log(req.url, " ", req.method, "", result);
        })
        .catch((error) => {
          const result = {
            message: "Error sending message",
            error: error,
          };

          console.log(req.url, " ", req.method, "", result);
        });
    })
    .catch((error) => {
      const result = {
        message: "Error getting tokens from database",
        error: error,
      };

      console.log(req.url, " ", req.method, "", result);
    });
};

module.exports = {
  addTemperature,
  getTemperatureHistory,
  addHeartbeat,
  getHeartBeatHistory,
  pushButtonClicked,
};
