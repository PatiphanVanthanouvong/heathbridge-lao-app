import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:heathbridge_lao/src/models/service_model.dart';
import 'package:heathbridge_lao/src/utils/hasura_helper.dart';

class ServiceProvider extends ChangeNotifier {
  List<Services> _serviceList = [];
  List<Services> get serviceList => _serviceList;

  bool isGettingService = false;

  Future<List<Services>> fetchServices() async {
    HasuraConnect connection = HasuraHelper.hasuraHelper;
    String request = """
    query MyQuery {
      services {
        name_en
        name_la
        service_id
        type
      }
    }
    """;

    var data = await connection.query(request, variables: {});
    if (data['data'] != null && data['data']['services'] != null) {
      List<dynamic> serviceData = data['data']['services'];
      return serviceData.map((e) => Services.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> getServiceList() async {
    isGettingService = true;
    notifyListeners();

    try {
      _serviceList = await fetchServices();
      print("Services fetched successfully: $_serviceList");
    } catch (e) {
      print("Error fetching services: $e");
    } finally {
      isGettingService = false;
      notifyListeners();
    }
  }
}
