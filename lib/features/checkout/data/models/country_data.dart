import 'dart:convert';

List<CountryData> countryDataFromJson(String str) => List<CountryData>.from(
    json.decode(str).map((x) => CountryData.fromJson(x)));

class CountryData {
  final String code;
  final String name;
  final List<State> states;

  CountryData({
    required this.code,
    required this.name,
    required this.states,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        code: json["code"],
        name: json["name"],
        states: List<State>.from(json["states"].map((x) => State.fromJson(x))),
      );
}

class State {
  final String code;
  final String name;

  State({
    required this.code,
    required this.name,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
        code: json["code"].toString(),
        name: json["name"],
      );
}

var countryData = {
  "code": "EG",
  "name": "Egypt",
  "states": [
    {"code": "EGALX", "name": "Alexandria"},
    {"code": "EGASN", "name": "Aswan"},
    {"code": "EGAST", "name": "Asyut"},
    {"code": "EGBA", "name": "Red Sea"},
    {"code": "EGBH", "name": "Beheira"},
    {"code": "EGBNS", "name": "Beni Suef"},
    {"code": "EGC", "name": "Cairo"},
    {"code": "EGDK", "name": "Dakahlia"},
    {"code": "EGDT", "name": "Damietta"},
    {"code": "EGFYM", "name": "Faiyum"},
    {"code": "EGGH", "name": "Gharbia"},
    {"code": "EGGZ", "name": "Giza"},
    {"code": "EGIS", "name": "Ismailia"},
    {"code": "EGJS", "name": "South Sinai"},
    {"code": "EGKB", "name": "Qalyubia"},
    {"code": "EGKFS", "name": "Kafr el-Sheikh"},
    {"code": "EGKN", "name": "Qena"},
    {"code": "EGLX", "name": "Luxor"},
    {"code": "EGMN", "name": "Minya"},
    {"code": "EGMNF", "name": "Monufia"},
    {"code": "EGMT", "name": "Matrouh"},
    {"code": "EGPTS", "name": "Port Said"},
    {"code": "EGSHG", "name": "Sohag"},
    {"code": "EGSHR", "name": "Al Sharqia"},
    {"code": "EGSIN", "name": "North Sinai"},
    {"code": "EGSUZ", "name": "Suez"},
    {"code": "EGWAD", "name": "New Valley"},
    {"code": "EG0", "name": "\u0627\u0644\u0642\u0627\u0647\u0631\u0629"},
    {
      "code": "EG1",
      "name": "\u0627\u0644\u0625\u0633\u0643\u0646\u062f\u0631\u064a\u0629"
    },
    {"code": "EG2", "name": "\u0627\u0644\u062f\u0642\u0647\u0644\u064a\u0629"},
    {"code": "EG3", "name": "\u0627\u0644\u0645\u0646\u0635\u0648\u0631\u0629"}
  ],
};
