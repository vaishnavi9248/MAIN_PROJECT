class HospitalModel {
  final String name, phone, location, address;
  final int pinCode;

  HospitalModel({
    required this.name,
    required this.phone,
    required this.location,
    required this.address,
    required this.pinCode,
  });
}

List<HospitalModel> hospitalList = [
  HospitalModel(
    name: "Taluk Hospital",
    phone: "0494 260 8282",
    location: "kuttippuram",
    address: "GOVERNMENT HOSPITAL, V23P+9PV, NH 17, Kuttippuram",
    pinCode: 679571,
  ),
  HospitalModel(
    name: "Amana Hospital",
    phone: "0494 260 7999",
    location: "kuttippuram",
    address: "Kavumopuram, Kuttippuram",
    pinCode: 679571,
  ),
  HospitalModel(
    name: "Hayath Medicare",
    phone: "75929 97991",
    location: "kuttippuram",
    address: "Tirur - Kuttippuram Rd, Kavumopuram, Kuttippuram",
    pinCode: 679571,
  ),
  HospitalModel(
    name: "Micron Diagnostics&ECG Center",
    phone: "099468 78178",
    location: "kuttippuram",
    address: "R2VJ+RR6, Tirur - Kuttippuram Rd, Kavumopuram, Kuttippuram",
    pinCode: 679571,
  ),
  HospitalModel(
    name: "CH Memorial Hospital",
    phone: "0494 264 4774",
    location: "valanchery",
    address: "Perinthalmanna Rd, near Police Station, Valanchery",
    pinCode: 676552,
  ),
  HospitalModel(
    name: "Nadakkavil Hospital",
    phone: "099461 47238",
    location: "valanchery",
    address: "Valanchery, Kerala",
    pinCode: 676552,
  ),
  HospitalModel(
    name: "Nizar Hospital",
    phone: "075598 34884",
    location: "valanchery",
    address: "Pattambi - Perinthalmanna Rd, Vadakancheri, Valanchery,",
    pinCode: 676552,
  ),
  HospitalModel(
    name: "Karuna Hospital",
    phone: "0494 264 4430",
    location: "valanchery",
    address: "Pattambi Rd, Vadakancheri, Valanchery",
    pinCode: 676552,
  ),
  HospitalModel(
    name: "Primary Health Centre, Valanchery",
    phone: "0494 264 6374",
    location: "valanchery",
    address: "Valanchery, Kerala",
    pinCode: 676552,
  ),
  HospitalModel(
    name: "Edappal Hospitals Pvt Ltd",
    phone: "0494 266 0200",
    location: "Edappal",
    address: "Pattambi Rd, Edappal",
    pinCode: 679576,
  ),
  HospitalModel(
    name: "Sukapuram Hospital",
    phone: "0494 268 1348",
    location: "Edappal",
    address: "Q2H5+GJX, Sukapuram P O, Edappal, Changaramkulam",
    pinCode: 679576,
  ),
  HospitalModel(
    name: "Sunrise Hospital",
    phone: "0494 265 0881",
    location: "Changaramkulam",
    address: "Thrissur - Kunnamkulam Rd, near Petrol Pumb",
    pinCode: 679575,
  ),
];
