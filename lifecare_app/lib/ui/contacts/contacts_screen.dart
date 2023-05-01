import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lifecare/data/models/contacts_model.dart';
import 'package:lifecare/data/repository/contact_repository.dart';
import 'package:lifecare/ui/contacts/contacts_add_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<ContactsModel> contactsList = [];

  TextEditingController controller = TextEditingController();

  ContactRepository contactRepository = ContactRepository();

  bool loading = true;

  List<ContactsModel> contactsGlobalList = [
    ContactsModel(name: "Police Station", number: 100),
    ContactsModel(name: "Fire Station", number: 101),
    ContactsModel(name: "Ambulance", number: 108),
  ];

  @override
  void initState() {
    getContactList();
    super.initState();
  }

  Future<void> getContactList() async {
    setState(() => loading = true);

    List<ContactsModel> data = await contactRepository.getContacts();

    contactsList = [...contactsGlobalList, ...data];
    contactsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    setState(() => loading = false);
    contactsGlobalList = contactsList;
  }

  Future<void> addNewContact({required ContactsModel contact}) async {
    setState(() => loading = true);

    Map body = {
      "name": contact.name,
      "phone": contact.number.toString(),
    };

    ContactsModel data = await contactRepository.addContact(body: body);

    if (data.id.isNotEmpty) {
      contactsList.add(contact);
      contactsList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      contactsGlobalList = contactsList;
    }

    setState(() => loading = false);
  }

  Future<void> updateContact({required ContactsModel contact}) async {
    setState(() => loading = true);

    Map body = {
      "id": contact.id,
      "name": contact.name,
      "phone": contact.number.toString(),
    };

    bool response = await contactRepository.updateContact(body: body);

    if (response) {
      contactsList.removeWhere((element) => element.id == contact.id);
      contactsList.add(contact);
      contactsList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      contactsGlobalList = contactsList;
    }

    setState(() => loading = false);
  }

  Future<void> deleteContact({required ContactsModel contact}) async {
    setState(() => loading = true);

    bool response = await contactRepository.deleteContact(id: contact.id);

    if (response) {
      contactsList.removeWhere((element) => element.id == contact.id);

      contactsGlobalList = contactsList;
    }

    setState(() => loading = false);
  }

  void onSearch({required String text}) {
    setState(() => loading = true);

    if (text.isEmpty) {
      contactsList = contactsGlobalList;
      contactsList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else {
      contactsList = contactsGlobalList
          .where((element) =>
              element.name.toLowerCase().contains(text.toLowerCase()) ||
              element.number
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()))
          .toList();
      contactsList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    setState(() => loading = false);
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
          ContactsModel? newContact = await Get.bottomSheet(
            const ContactsAddScreen(),
            isScrollControlled: true,
          );

          if (newContact != null) {
            addNewContact(contact: newContact);
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
                  onSearch(text: value);
                },
                decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : contactsList.isNotEmpty
                      ? ListView.builder(
                          itemCount: contactsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            ContactsModel contact = contactsList[index];

                            return InkWell(
                              onTap: contact.id.isNotEmpty
                                  ? () async {
                                      ContactsModel? newContact =
                                          await Get.bottomSheet(
                                        ContactsAddScreen(
                                            contactsModule: contact),
                                        isScrollControlled: true,
                                      );

                                      if (newContact != null) {
                                        if (newContact.id == "delete") {
                                          deleteContact(contact: contact);
                                        } else {
                                          updateContact(contact: newContact);
                                        }
                                      }
                                    }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name: ${contact.name}",
                                            style: const TextStyle(
                                                letterSpacing: 1),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            "Phone: ${contact.number}",
                                            style: const TextStyle(
                                                letterSpacing: 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          launchUrl(Uri.parse(
                                              "tel:${contact.number}"));
                                        },
                                        icon: const Icon(Icons.call)),
                                  ],
                                ),
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
