import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:heathbridge_lao/src/models/facilities_model.dart';
import 'package:heathbridge_lao/src/utils/hasura_helper.dart';

class FacilityProvider extends ChangeNotifier {
  List<Facilities> _facData = [];
  List<Facilities> get facData => _facData;

  bool _isGettingFacInfo = false;
  bool get isGettingFacInfo => _isGettingFacInfo;

  Future<void> getFacInfo() async {
    _isGettingFacInfo = true;
    notifyListeners();

    try {
      _facData = await _fetchFacilities();
      print("Facilities fetched successfully: $_facData");
    } catch (e) {
      print("Error fetching facilities: $e");
      _facData = [];
    } finally {
      _isGettingFacInfo = false;
      notifyListeners();
    }
  }

  Future<List<Facilities>> _fetchFacilities() async {
    HasuraConnect connection = HasuraHelper.hasuraHelper;
    String request = """
         query facilities {
              facilities {
                fac_id
                fac_type_id
                name
                village
                district
                province
                contact_info
                Latitude
                Longitude
                status
                rating_count
                facility_type {
                  name_en
                  name_la
                  type
                  description
                }
              }
            }
      """;

    var data = await connection.query(request);
    print("GraphQL Response: $data");
    List<dynamic> res = data['data']['facilities'];
    return res.map((e) => Facilities.fromJson(e)).toList();
  }
}
