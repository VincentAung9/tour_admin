// ignore: file_names
class Country {
  final String flag;
  final String country;
  final String code;
  Country({required this.flag, required this.country, required this.code});
  factory Country.fromJson(Map<String, dynamic> json) => Country(
        flag: json["flag"],
        country: json["country"],
        code: json["code"],
      );
}
