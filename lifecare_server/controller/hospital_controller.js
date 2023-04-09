const Hospital = require("../models/hospital_model").hospital;

const getAllHospital = (req, res) => {
  Hospital.find()
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

const addHospital = (req, res) => {
  const { name, address, location, phone, pinCode } = req.body;

  let errorMap = {};

  if (!name) errorMap.name = "name is required";
  if (!address) errorMap.address = "address is required";
  if (!location) errorMap.location = "location is required";
  if (!phone) errorMap.phone = "phone is required";
  if (!pinCode) errorMap.pinCode = "pinCode is required";

  if (errorMap.size > 0) {
    console.log(req.url, " ", req.method, "", errorMap);

    return res.status(422).json(errorMap);
  }

  const hospital = new Hospital({
    name,
    address,
    location,
    phone: phone.replaceAll(" ", ""),
    pinCode: pinCode.replaceAll(" ", ""),
  });

  hospital.save().then((data) => {
    const result = {
      message: "Hospital added successfully",
      data: data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

const deleteHospital = (req, res) => {
  const id = req.params.id;

  Hospital.deleteOne({ _id: id }).then((data) => {
    const result = {
      message: "Hospital deleted successfully",
      data: data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

module.exports = {
  addHospital,
  getAllHospital,
  deleteHospital,
};
