// To parse this JSON data, do
//
//     final projects = projectsFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'projects.g.dart';

Projects projectsFromJson(String str) => Projects.fromJson(json.decode(str));

String projectsToJson(Projects data) => json.encode(data.toJson());

class Projects {
  Projects({
    this.project,
    this.error,
    this.statusCode
  });

  List<Project>? project;
  String? error;
  int? statusCode;

  factory Projects.fromJson(Map<String, dynamic> json) => Projects(
        project:
            List<Project>.from(json["project"].map((x) => Project.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "project": List<dynamic>.from(project!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 46)
class Project {
  Project({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.extraImages,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  List<dynamic> extraImages;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        name: json["name"],
        description: json["description"],
        imageUrl: json["image_url"],
        extraImages: List<dynamic>.from(json["extra_images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "image_url": imageUrl,
        "extra_images": List<dynamic>.from(extraImages.map((x) => x)),
      };
}
