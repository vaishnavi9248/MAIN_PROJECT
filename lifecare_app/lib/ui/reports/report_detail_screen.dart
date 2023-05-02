import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lifecare/data/models/doc_model.dart';
import 'package:lifecare/data/models/report_model.dart';
import 'package:lifecare/data/repository/report_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({
    Key? key,
    this.reportModel,
  }) : super(key: key);

  final ReportModel? reportModel;

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  ReportRepository reportRepository = ReportRepository();

  TextEditingController titleCon = TextEditingController();
  TextEditingController desCon = TextEditingController();

  ReportModel? reportModel;

  bool loading = true;

  List<DocModel> docList = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    if (widget.reportModel != null) {
      reportModel = widget.reportModel;
      titleCon.text = widget.reportModel?.title ?? "";
      desCon.text = widget.reportModel?.description ?? "";
      getDocs();
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> getDocs() async {
    setState(() => loading = true);

    List<DocModel> data =
        await reportRepository.getDocs(noteId: reportModel?.id ?? "");

    docList = data.reversed.toList();

    setState(() => loading = false);
  }

  Future<void> deleteDoc({required String id}) async {
    await reportRepository.deleteDoc(id: id);
    getDocs();
  }

  Future<void> fileUploadAction({required String noteId}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if ((result?.files.single.path ?? "").isNotEmpty) {
      setState(() => loading = true);

      File file = File(result!.files.single.path!);

      final String fileName = file.path.split("/").last;

      final String url = await uploadFile(file: file, name: fileName);

      if (noteId.isNotEmpty) {
        addDoc(noteId: noteId, fileName: fileName, url: url);
      } else {
        Map body = {
          "title": "",
          "description": "",
        };

        ReportModel data = await reportRepository.addReport(body: body);

        setState(() => reportModel = data);

        addDoc(noteId: data.id, fileName: fileName, url: url);
      }
    }
  }

  Future<String> uploadFile({required File file, required String name}) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(DateTime.now().microsecondsSinceEpoch.toString() + name);

    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<void> addDoc({
    required String url,
    required String noteId,
    required String fileName,
  }) async {
    Map body = {"url": url, "noteId": noteId, "name": fileName};

    await reportRepository.addDoc(body: body);
    getDocs();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.reportModel == null && (reportModel?.id ?? "").isNotEmpty) {
          Get.back(
              result: ReportModel(
            id: "refresh",
            title: "",
            description: "",
          ));
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Report Detail"),
          centerTitle: false,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          elevation: 0,
          backgroundColor: Colors.teal,
          actions: [
            if ((reportModel?.id ?? "").isNotEmpty)
              TextButton(
                onPressed: () {
                  Get.back(
                      result: ReportModel(
                    id: "delete",
                    title: "",
                    description: "",
                  ));
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            const VerticalDivider(
              color: Colors.white,
              width: 2.0,
              thickness: 1.0,
              endIndent: 8,
              indent: 8,
            ),
            TextButton(
              onPressed: () {
                Get.back(
                    result: ReportModel(
                  id: reportModel?.id ?? "",
                  title: titleCon.text,
                  description: desCon.text,
                ));
              },
              child: Text(
                reportModel != null ? "Update" : "Save",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => fileUploadAction(noteId: reportModel?.id ?? ""),
          child: const Icon(Icons.attach_file),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleCon,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: "Title",
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: desCon,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 12,
                    decoration: const InputDecoration(
                      hintText: "Description",
                      labelText: "Description",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (loading)
                    const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Documents: ${docList.length}",
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        ListView.builder(
                          itemCount: docList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            DocModel report = docList[index];

                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${index + 1}. ${report.name}",
                                        maxLines: 1,
                                        style: const TextStyle(
                                            letterSpacing: 1,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    IconButton(
                                        onPressed: () =>
                                            deleteDoc(id: report.id),
                                        icon: const Icon(Icons.delete)),
                                    IconButton(
                                        onPressed: () => launchUrl(
                                            Uri.parse(report.url),
                                            mode:
                                                LaunchMode.externalApplication),
                                        icon: const Icon(Icons.remove_red_eye)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 50.0),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
