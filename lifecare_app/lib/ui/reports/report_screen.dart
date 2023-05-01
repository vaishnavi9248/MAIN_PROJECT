import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifecare/data/models/report_model.dart';
import 'package:lifecare/data/repository/report_repository.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<ReportModel> reportList = [];

  TextEditingController controller = TextEditingController();

  ReportRepository reportRepository = ReportRepository();

  bool loading = true;

  List<ReportModel> reportGlobalList = [];

  @override
  void initState() {
    getReportList();
    super.initState();
  }

  Future<void> getReportList() async {
    setState(() => loading = true);

    List<ReportModel> data = await reportRepository.getReports();

    reportList = data.reversed.toList();
    reportGlobalList = reportList;

    setState(() => loading = false);
  }

  // Future<void> addNewContact({required ReportModel contact}) async {
  //   setState(() => loading = true);
  //
  //   Map body = {
  //     "name": contact.name,
  //     "phone": contact.number.toString(),
  //   };
  //
  //   ReportModel data = await reportRepository.addContact(body: body);
  //
  //   if (data.id.isNotEmpty) {
  //     reportList.add(data);
  //     reportList
  //         .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  //
  //     reportGlobalList = reportList;
  //   }
  //
  //   setState(() => loading = false);
  // }
  //
  // Future<void> updateContact({required ReportModel contact}) async {
  //   setState(() => loading = true);
  //
  //   Map body = {
  //     "id": contact.id,
  //     "name": contact.name,
  //     "phone": contact.number.toString(),
  //   };
  //
  //   bool response = await reportRepository.updateContact(body: body);
  //
  //   if (response) {
  //     reportList.removeWhere((element) => element.id == contact.id);
  //     reportList.add(contact);
  //     reportList
  //         .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  //
  //     reportGlobalList = reportList;
  //   }
  //
  //   setState(() => loading = false);
  // }
  //
  // Future<void> deleteContact({required ReportModel contact}) async {
  //   setState(() => loading = true);
  //
  //   bool response = await reportRepository.deleteContact(id: contact.id);
  //
  //   if (response) {
  //     reportList.removeWhere((element) => element.id == contact.id);
  //
  //     reportGlobalList = reportList;
  //   }
  //
  //   setState(() => loading = false);
  // }

  void onSearch({required String text}) {
    setState(() => loading = true);

    if (text.isEmpty) {
      reportList = reportGlobalList;
    } else {
      reportList = reportGlobalList
          .where((element) =>
              element.title.toLowerCase().contains(text.toLowerCase()) ||
              element.description.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        centerTitle: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ReportModel? newContact = await Get.bottomSheet(
          //   const ContactsAddScreen(),
          //   isScrollControlled: true,
          // );
          //
          // if (newContact != null) {
          //   addNewContact(contact: newContact);
          // }
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
                  : reportList.isNotEmpty
                      ? ListView.builder(
                          itemCount: reportList.length,
                          itemBuilder: (BuildContext context, int index) {
                            ReportModel contact = reportList[index];

                            return InkWell(
                              onTap: contact.id.isNotEmpty
                                  ? () async {
                                      // ReportModel? newContact =
                                      //     await Get.bottomSheet(
                                      //   ContactsAddScreen(
                                      //       contactsModule: contact),
                                      //   isScrollControlled: true,
                                      // );
                                      //
                                      // if (newContact != null) {
                                      //   if (newContact.id == "delete") {
                                      //     deleteContact(contact: contact);
                                      //   } else {
                                      //     updateContact(contact: newContact);
                                      //   }
                                      // }
                                    }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.3),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 8.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 10.0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Title: ${contact.title}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      "Desc: ${contact.description}",
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            controller.text.isEmpty
                                ? "Please add new contact"
                                : "No contact found",
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
