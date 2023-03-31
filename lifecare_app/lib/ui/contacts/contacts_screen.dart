import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lifecare/data/models/contacts_module.dart';
import 'package:lifecare/ui/contacts/contacts_add_screen.dart';
import 'package:url_launcher/url_launcher.dart';

List<ContactsModule> contactsGlobalList = [
  ContactsModule(name: "Police Station", number: 100),
  ContactsModule(name: "Fire Station", number: 101),
  ContactsModule(name: "Ambulance", number: 108),
];

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<ContactsModule> contactsList = [];

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    contactsList = contactsGlobalList;
    contactsList.sort((a, b) => a.name.compareTo(b.name));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency contacts"),
        centerTitle: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ContactsModule? newContact = await Get.bottomSheet(
            const ContactsAddScreen(),
            isScrollControlled: true,
          );

          if (newContact != null) {
            contactsGlobalList.add(newContact);
            contactsGlobalList.sort((a, b) => a.name.compareTo(b.name));
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controller,
                onChanged: (String value) {
                  if (value.isEmpty) {
                    contactsList = contactsGlobalList;
                    contactsList.sort((a, b) => a.name.compareTo(b.name));
                  } else {
                    contactsList = contactsGlobalList
                        .where((element) =>
                            element.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            element.number
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                        .toList();
                    contactsList.sort((a, b) => a.name.compareTo(b.name));
                  }
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: contactsList.isNotEmpty
                  ? ListView.builder(
                      itemCount: contactsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        ContactsModule hospital = contactsList[index];

                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.3),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name: ${hospital.name}",
                                      style: const TextStyle(letterSpacing: 1),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      "Phone: ${hospital.number}",
                                      style: const TextStyle(letterSpacing: 1),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    launchUrl(
                                        Uri.parse("tel:${hospital.number}"));
                                  },
                                  icon: const Icon(Icons.call)),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(controller.text.isEmpty
                          ? "Please add new contact"
                          : "No contact found"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
