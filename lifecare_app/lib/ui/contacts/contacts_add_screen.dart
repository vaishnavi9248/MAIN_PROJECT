import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifecare/data/models/contacts_model.dart';

class ContactsAddScreen extends StatefulWidget {
  const ContactsAddScreen({Key? key, this.contactsModule}) : super(key: key);

  final ContactsModel? contactsModule;

  @override
  State<ContactsAddScreen> createState() => _ContactsAddScreenState();
}

class _ContactsAddScreenState extends State<ContactsAddScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    if (widget.contactsModule != null) {
      nameController.text = widget.contactsModule?.name ?? "";
      numberController.text = widget.contactsModule?.number.toString() ?? "";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              const Center(
                child: Text(
                  "Add Contact",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Name",
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (String? value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Name is mandatory";
                    }
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: numberController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                decoration: const InputDecoration(
                  hintText: "Phone number",
                  labelText: "Phone number",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (String? value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Name is mandatory";
                    }
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (widget.contactsModule?.name !=
                                  nameController.text ||
                              widget.contactsModule?.number.toString() !=
                                  numberController.text) {
                            ContactsModel contact = ContactsModel(
                              id: widget.contactsModule?.id ?? "",
                              name: nameController.text,
                              number: int.parse(numberController.text),
                            );

                            Get.back(result: contact);
                          } else {
                            Get.back();
                          }
                        }
                      },
                      child: Text(
                          widget.contactsModule != null ? "Update" : "Save"),
                    ),
                  ),
                  if (widget.contactsModule != null) ...[
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.red),
                        onPressed: () {
                          ContactsModel contact = ContactsModel(
                            id: "delete",
                            name: "",
                            number: 0,
                          );

                          Get.back(result: contact);
                        },
                        child: const Text("Delete"),
                      ),
                    ),
                  ],
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
