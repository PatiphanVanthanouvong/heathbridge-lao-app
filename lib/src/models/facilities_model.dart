// To parse this JSON data, do
//
//     final facilities = facilitiesFromJson(jsonString);

import 'dart:convert';

Facilities facilitiesFromJson(String str) =>
    Facilities.fromJson(json.decode(str));

String facilitiesToJson(Facilities data) => json.encode(data.toJson());

class Facilities {
  final String? facId;
  final FacilityType? facilityType;
  final List<ServiceDetail>? serviceDetails;
  final String? latitude;
  final String? longitude;
  final String? contactInfo;
  final String? district;
  final String? name;
  final String? province;
  final dynamic imageUrl;
  final dynamic ratingCount;
  final String? village;
  final int? status;

  Facilities({
    this.facId,
    this.facilityType,
    this.serviceDetails,
    this.latitude,
    this.longitude,
    this.contactInfo,
    this.district,
    this.name,
    this.province,
    this.imageUrl,
    this.ratingCount,
    this.village,
    this.status,
  });

  factory Facilities.fromJson(Map<String, dynamic> json) => Facilities(
        facId: json["fac_id"],
        facilityType: json["facility_type"] == null
            ? null
            : FacilityType.fromJson(json["facility_type"]),
        serviceDetails: json["service_details"] == null
            ? []
            : List<ServiceDetail>.from(
                json["service_details"]!.map((x) => ServiceDetail.fromJson(x))),
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        contactInfo: json["contact_info"],
        district: json["district"],
        name: json["name"],
        province: json["province"],
        imageUrl: json["image_url"],
        ratingCount: json["rating_count"],
        village: json["village"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "fac_id": facId,
        "facility_type": facilityType?.toJson(),
        "service_details": serviceDetails == null
            ? []
            : List<dynamic>.from(serviceDetails!.map((x) => x.toJson())),
        "Latitude": latitude,
        "Longitude": longitude,
        "contact_info": contactInfo,
        "district": district,
        "name": name,
        "province": province,
        "image_url": imageUrl,
        "rating_count": ratingCount,
        "village": village,
        "status": status,
      };
}

class FacilityType {
  final String? nameEn;
  final String? type;
  final dynamic description;
  final String? nameLa;

  FacilityType({
    this.nameEn,
    this.type,
    this.description,
    this.nameLa,
  });

  factory FacilityType.fromJson(Map<String, dynamic> json) => FacilityType(
        nameEn: json["name_en"],
        type: json["type"],
        description: json["description"],
        nameLa: json["name_la"],
      );

  Map<String, dynamic> toJson() => {
        "name_en": nameEn,
        "type": type,
        "description": description,
        "name_la": nameLa,
      };
}

class ServiceDetail {
  final Service? service;

  ServiceDetail({
    this.service,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) => ServiceDetail(
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "service": service?.toJson(),
      };
}

class Service {
  final String? nameEn;
  final String? type;

  Service({
    this.nameEn,
    this.type,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        nameEn: json["name_en"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name_en": nameEn,
        "type": type,
      };
}
