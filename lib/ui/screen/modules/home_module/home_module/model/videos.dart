// To parse this JSON data, do
//
//     final videosApiResponse = videosApiResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'videos.g.dart';

VideosApiResponse videosApiResponseFromJson(String str) =>
    VideosApiResponse.fromJson(json.decode(str));

String videosApiResponseToJson(VideosApiResponse data) =>
    json.encode(data.toJson());

class VideosApiResponse {
  VideosApiResponse({this.videos, this.error, this.statusCode});

  List<Video>? videos;
  String? error;
  int? statusCode;

  factory VideosApiResponse.fromJson(Map<String, dynamic> json) =>
      VideosApiResponse(
        videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "videos": List<dynamic>.from(videos!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 47)
class Video {
  Video({
    required this.name,
    required this.type,
    required this.videoUrl,
    required this.description,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String type;

  @HiveField(2)
  String videoUrl;

  @HiveField(3)
  DateTime? createdDate;

  @HiveField(4)
  String? description;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
      name: json["name"],
      type: json["type"],
      videoUrl: json["video_url"],
      description: json["description"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "video_url": videoUrl,
        "description": description
      };
}
