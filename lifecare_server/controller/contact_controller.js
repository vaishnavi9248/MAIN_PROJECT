const Contact = require("../models/contact_model").contact;

const getAllContact = (req, res) => {
  Contact.find()
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

const addContact = (req, res) => {
  const { name, phone } = req.body;

  let errorMap = {};

  if (!name) errorMap.name = "name is required";
  if (!phone) errorMap.phone = "phone is required";

  if (errorMap.size > 0) {
    console.log(req.url, " ", req.method, "", errorMap);

    return res.status(422).json(errorMap);
  }

  function replaceAll(str, find, replace) {
    return str.replace(new RegExp(find, "g"), replace);
  }

  const contact = new Contact({
    name,
    phone: replaceAll(phone, " ", ""),
  });

  contact.save().then((data) => {
    const result = {
      message: "Contact added successfully",
      data: data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

const deleteContact = (req, res) => {
  const id = req.params.id;

  Contact.deleteOne({ _id: id }).then((data) => {
    const result = {
      message: "Contact deleted successfully",
      data: data,
    };

    console.log(req.url, " ", req.method, "", result);

    res.json(result);
  });
};

module.exports = {
  addContact,
  getAllContact,
  deleteContact,
};
