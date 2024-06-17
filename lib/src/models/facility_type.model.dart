// To parse this JSON data, do
//
//     final facTypeModel = facTypeModelFromJson(jsonString);

import 'dart:convert';

FacTypeModel facTypeModelFromJson(String str) =>
    FacTypeModel.fromJson(json.decode(str));

String facTypeModelToJson(FacTypeModel data) => json.encode(data.toJson());

class FacTypeModel {
  final String? facTypeId;
  final String? nameEn;
  final String? nameLa;
  final String? type;

  FacTypeModel({
    this.facTypeId,
    this.nameEn,
    this.nameLa,
    this.type,
  });

  factory FacTypeModel.fromJson(Map<String, dynamic> json) => FacTypeModel(
        facTypeId: json["fac_type_id"],
        nameEn: json["name_en"],
        nameLa: json["name_la"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "fac_type_id": facTypeId,
        "name_en": nameEn,
        "name_la": nameLa,
        "type": type,
      };
}
