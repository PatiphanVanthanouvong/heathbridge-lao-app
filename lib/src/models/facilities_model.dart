// To parse this JSON data, do
//
//     final facilities = facilitiesFromJson(jsonString);

import 'dart:convert';

Facilities facilitiesFromJson(String str) =>
    Facilities.fromJson(json.decode(str));

String facilitiesToJson(Facilities data) => json.encode(data.toJson());

class Facilities {
  final String? facId;
  final String? facTypeId;
  final String? name;
  final String? village;
  final String? district;
  final String? province;
  final String? contactInfo;
  final String? latitude;
  final String? longitude;
  final int? status;
  final dynamic ratingCount;
  final FacilityType? facilityType;

  Facilities({
    this.facId,
    this.facTypeId,
    this.name,
    this.village,
    this.district,
    this.province,
    this.contactInfo,
    this.latitude,
    this.longitude,
    this.status,
    this.ratingCount,
    this.facilityType,
  });

  factory Facilities.fromJson(Map<String, dynamic> json) => Facilities(
        facId: json["fac_id"],
        facTypeId: json["fac_type_id"],
        name: json["name"],
        village: json["village"],
        district: json["district"],
        province: json["province"],
        contactInfo: json["contact_info"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        status: json["status"],
        ratingCount: json["rating_count"],
        facilityType: json["facility_type"] == null
            ? null
            : FacilityType.fromJson(json["facility_type"]),
      );

  Map<String, dynamic> toJson() => {
        "fac_id": facId,
        "fac_type_id": facTypeId,
        "name": name,
        "village": village,
        "district": district,
        "province": province,
        "contact_info": contactInfo,
        "Latitude": latitude,
        "Longitude": longitude,
        "status": status,
        "rating_count": ratingCount,
        "facility_type": facilityType?.toJson(),
      };
}

class FacilityType {
  final String? facTypeId;
  final String? nameEn;
  final String? nameLa;
  final String? type;
  final dynamic description;

  FacilityType({
    this.facTypeId,
    this.nameEn,
    this.nameLa,
    this.type,
    this.description,
  });

  factory FacilityType.fromJson(Map<String, dynamic> json) => FacilityType(
        facTypeId: json["fac_type_id"],
        nameEn: json["name_en"],
        nameLa: json["name_la"],
        type: json["type"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "fac_type_id": facTypeId,
        "name_en": nameEn,
        "name_la": nameLa,
        "type": type,
        "description": description,
      };
}
