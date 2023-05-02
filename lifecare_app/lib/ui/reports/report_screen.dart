import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifecare/data/models/report_model.dart';
import 'package:lifecare/data/repository/report_repository.dart';
import 'package:lifecare/ui/reports/report_detail_screen.dart';

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

  Future<void> addNewReport({required ReportModel report}) async {
    setState(() => loading = true);

    Map body = {
      "title": report.title,
      "description": report.description,
    };

    ReportModel data = await reportRepository.addReport(body: body);

    if (data.id.isNotEmpty) {
      reportList.insert(0, data);

      reportGlobalList = reportList;
    }

    setState(() => loading = false);
  }

  Future<void> updateReport({required ReportModel report}) async {
    setState(() => loading = true);

    Map body = {
      "id": report.id,
      "title": report.title,
      "description": report.description,
    };

    await reportRepository.updateReport(body: body);

    getReportList();
  }

  Future<void> deleteReport({required ReportModel report}) async {
    setState(() => loading = true);

    bool response = await reportRepository.deleteReport(id: report.id);

    if (response) {
      reportList.removeWhere((element) => element.id == report.id);

      reportGlobalList = reportList;
    }

    setState(() => loading = false);
  }

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
          ReportModel? reportModel = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ReportDetailScreen()));

          if (reportModel != null) {
            if (reportModel.id.isEmpty) {
              addNewReport(report: reportModel);
            } else if (reportModel.id == "refresh") {
              getReportList();
            } else {
              updateReport(report: reportModel);
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loading ? () async => false : () async => getReportList(),
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
                              ReportModel report = reportList[index];

                              return InkWell(
                                onTap: report.id.isNotEmpty
                                    ? () async {
                                        ReportModel? reportModel =
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReportDetailScreen(
                                                            reportModel:
                                                                report)));

                                        if (reportModel != null) {
                                          if (reportModel.id.isEmpty) {
                                            addNewReport(report: reportModel);
                                          } else {
                                            if (reportModel.id == "delete") {
                                              deleteReport(report: report);
                                            } else if (reportModel.id ==
                                                "refresh") {
                                              getReportList();
                                            } else {
                                              updateReport(report: reportModel);
                                            }
                                          }
                                        }
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Title: ${report.title}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        "Desc: ${report.description}",
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
                                  ? "Please add new report"
                                  : "No report found",
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
