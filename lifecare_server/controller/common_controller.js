const FCMToken = require("../models/fcm_token_model").token;

const addFCM = (req, res) => {
  const { deviceId, token } = req.body;

  let errorMap = {};

  if (!deviceId || !token) {
    errorMap.error = "Please input all fields";
    if (!deviceId) errorMap.name = "deviceId is required";
    if (!token) errorMap.token = "token is required";

    console.log(req.url, " ", req.method, "", errorMap);
    return res.status(422).json(errorMap);
  }

  var query = { deviceId },
    update = { token },
    options = { upsert: true, new: true, setDefaultsOnInsert: true };

  FCMToken.findOneAndUpdate(query, update, options).then((data) => {
    const result = {
      message: "Successfully device added",
      data: data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

module.exports = {
  addFCM,
};
