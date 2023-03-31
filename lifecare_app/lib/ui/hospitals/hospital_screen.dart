import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifecare/data/models/hospital_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({Key? key}) : super(key: key);

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  List<HospitalModel> hospitalList = [];

  @override
  void initState() {
    hospitalList = hospitalGLobalList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearest Hospitals"),
        centerTitle: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (String value) {
                  if (value.isEmpty) {
                    hospitalList = hospitalGLobalList;
                  } else {
                    hospitalList = hospitalGLobalList
                        .where((element) =>
                            element.location
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            element.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            element.pinCode
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                        .toList();
                  }
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: "Search by name, location, pincode...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("Count: ${hospitalList.length}"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: hospitalList.length,
                itemBuilder: (BuildContext context, int index) {
                  HospitalModel hospital = hospitalList[index];

                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
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
                                "Phone: ${hospital.phone}",
                                style: const TextStyle(letterSpacing: 1),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                "Location: ${hospital.location}",
                                style: const TextStyle(letterSpacing: 1),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                "Pincode: ${hospital.pinCode}",
                                style: const TextStyle(letterSpacing: 1),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                "Address: ${hospital.address}",
                                style: const TextStyle(letterSpacing: 1),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              launchUrl(Uri.parse("tel:${hospital.phone}"));
                            },
                            icon: const Icon(Icons.call)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
