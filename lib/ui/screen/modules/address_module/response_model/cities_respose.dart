import 'dart:convert';

class CitiesListResponse {
  List<CitiesData>? cities;
  int? statusCode;
  String? error;

  CitiesListResponse({this.cities, this.statusCode, this.error});

  factory CitiesListResponse.fromJson(List<dynamic> json) {
    List<CitiesData> citiesList = [];
    for (var cityJson in json) {
      citiesList.add(CitiesData.fromJson(cityJson));
    }
    return CitiesListResponse(cities: citiesList);
  }
}

class CitiesData {
  dynamic name;
  dynamic city;
  dynamic stateId;
  dynamic stateName;
  dynamic stateCode;
  dynamic zip;
  dynamic countryId;
  dynamic countryName;
  dynamic countryCode;

  CitiesData({
    this.name,
    this.city,
    this.stateId,
    this.stateName,
    this.stateCode,
    this.zip,
    this.countryId,
    this.countryName,
    this.countryCode,
  });

  factory CitiesData.fromRawJson(dynamic str) =>
      CitiesData.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory CitiesData.fromJson(Map<dynamic, dynamic> json) => CitiesData(
        name: json["name"],
        city: json["city"],
        stateId: json["state_id"],
        stateName: json["state_name"],
        stateCode: json["state_code"],
        zip: json["zip"],
        countryId: json["country_id"],
        countryName: json["country_name"],
        countryCode: json["country_code"],
      );

  Map<dynamic, dynamic> toJson() => {
        "name": name,
        "city": city,
        "state_id": stateId,
        "state_name": stateName,
        "state_code": stateCode,
        "zip": zip,
        "country_id": countryId,
        "country_name": countryName,
        "country_code": countryCode,
      };
}
