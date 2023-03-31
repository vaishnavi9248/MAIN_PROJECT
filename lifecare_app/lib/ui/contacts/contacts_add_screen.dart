import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifecare/data/models/contacts_module.dart';

class ContactsAddScreen extends StatefulWidget {
  const ContactsAddScreen({Key? key}) : super(key: key);

  @override
  State<ContactsAddScreen> createState() => _ContactsAddScreenState();
}

class _ContactsAddScreenState extends State<ContactsAddScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ContactsModule contact = ContactsModule(
                      name: nameController.text,
                      number: int.parse(numberController.text),
                    );

                    Get.back(result: contact);
                  }
                },
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
