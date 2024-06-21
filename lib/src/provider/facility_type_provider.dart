import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:heathbridge_lao/src/models/facility_type.model.dart';
import 'package:heathbridge_lao/src/utils/hasura_helper.dart';

class FacTypeProvider extends ChangeNotifier {
  List<FacTypeModel> _typeList = [];
  List<FacTypeModel> get typeList => _typeList;

  bool isGettingService = false;

  Future<List<FacTypeModel>> fetchFactype() async {
    HasuraConnect connection = HasuraHelper.hasuraHelper;
    String request = """
 query MyQuery {
        facility_type(order_by: {name_en: asc}) {
          fac_type_id
          name_en
          name_la
          sub_type
        }
      }
    """;

    var data = await connection.query(request, variables: {});
    if (data['data'] != null && data['data']['facility_type'] != null) {
      List<dynamic> serviceData = data['data']['facility_type'];
      return serviceData.map((e) => FacTypeModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> getFacType() async {
    isGettingService = true;
    notifyListeners();

    try {
      _typeList = await fetchFactype();
      print("Services fetched successfully: $_typeList");
    } catch (e) {
      print("Error fetching services: $e");
    } finally {
      isGettingService = false;
      notifyListeners();
    }
  }
}
