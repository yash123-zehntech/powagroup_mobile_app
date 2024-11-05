// To parse this JSON data, do
//
//     final contentSliderApiResponse = contentSliderApiResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'content_slider.g.dart';

ContentSliderApiResponse contentSliderApiResponseFromJson(String str) =>
    ContentSliderApiResponse.fromJson(json.decode(str));

String contentSliderApiResponseToJson(ContentSliderApiResponse data) =>
    json.encode(data.toJson());

class ContentSliderApiResponse {
  ContentSliderApiResponse({this.sliders, this.error, this.statusCode});

  List<SliderData>? sliders;
  String? error;
  int? statusCode;

  factory ContentSliderApiResponse.fromJson(Map<String, dynamic> json) =>
      ContentSliderApiResponse(
        sliders: List<SliderData>.from(
            json["sliders"].map((x) => SliderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sliders": List<dynamic>.from(sliders!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 48)
class SliderData {
  SliderData({
    required this.sequence,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonUrl,
    required this.imageUrl,
    required this.isPublished,
  });

  @HiveField(0)
  int sequence;

  @HiveField(1)
  String title;

  @HiveField(2)
  dynamic subtitle;

  @HiveField(3)
  String buttonText;

  @HiveField(4)
  String buttonUrl;

  @HiveField(5)
  String imageUrl;

  @HiveField(6)
  bool isPublished;

  factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
        sequence: json["sequence"],
        title: json["title"],
        subtitle: json["subtitle"],
        buttonText: json["button_text"],
        buttonUrl: json["button_url"],
        imageUrl: json["image_url"],
        isPublished: json["is_published"],
      );

  Map<String, dynamic> toJson() => {
        "sequence": sequence,
        "title": title,
        "subtitle": subtitle,
        "button_text": buttonText,
        "button_url": buttonUrl,
        "image_url": imageUrl,
        "is_published": isPublished,
      };
}
