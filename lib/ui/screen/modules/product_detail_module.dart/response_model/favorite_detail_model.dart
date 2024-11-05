// import 'dart:convert';

// FavoriteResponseModel FavoriteResponseModelFromJson(String str) => FavoriteResponseModel.fromJson(json.decode(str));

// String FavoriteResponseModelToJson(FavoriteResponseModel data) => json.encode(data.toJson());

// class FavoriteResponseModel {
//     FavoriteResponseModel({
//         this.token,
//         this.error,
//         this.statusCode
//     });

//     String? token;
//     String? error;
//     int? statusCode;

//     factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) => FavoriteResponseModel(
//         token: json["token"] == null ? null : json["token"],
//     );

//     Map<String, dynamic> toJson() => {
//         "token": token == null ? null : token,
//     };
// }


import 'dart:convert';

FavoriteResponseModel favoriteResponseModelFromJson(String str) => FavoriteResponseModel.fromJson(json.decode(str));

String favoriteResponseModelToJson(FavoriteResponseModel data) => json.encode(data.toJson());

class FavoriteResponseModel {
    FavoriteResponseModel({
        this.status,this.error, this.statusCode
    });

    String? status;
    String? error;
    int? statusCode;

    factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) => FavoriteResponseModel(
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
    };
}
