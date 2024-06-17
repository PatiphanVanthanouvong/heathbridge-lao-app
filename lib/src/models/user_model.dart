// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final String? firstname;
    final String? lastname;
    final String? email;
    final String? tel;
    final String? gender;
    final String? password;

    UserModel({
        this.firstname,
        this.lastname,
        this.email,
        this.tel,
        this.gender,
        this.password,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        tel: json["tel"],
        gender: json["gender"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "tel": tel,
        "gender": gender,
        "password": password,
    };
}
