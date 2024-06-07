import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:heathbridge_lao/src/models/facilities_model.dart';
import 'package:heathbridge_lao/src/utils/hasura_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacilityProvider extends ChangeNotifier {
  List<Facilities> _facData = [];
  List<Facilities> get facData => _facData;

  Facilities? _oneFac;
  Facilities get oneFac => _oneFac!;

  bool _isGettingFacInfo = false;
  bool get isGettingFacInfo => _isGettingFacInfo;

  bool isGettingDetails = false;

  Future<void> getFacInfo() async {
    _isGettingFacInfo = true;
    notifyListeners();

    try {
      _facData = await _searchFacility();
      print("Facilities fetched successfully: $_facData");
    } catch (e) {
      print("Error fetching facilities: $e");
      _facData = [];
    } finally {
      _isGettingFacInfo = false;
      notifyListeners();
    }
  }

  Future<void> getDetailEach({String? facId}) async {
    isGettingDetails = true;
    notifyListeners();

    try {
      _oneFac = await _getOneFacilities(id: facId);
      print("Facilities fetched One successfully!!!$_oneFac");
    } catch (e) {
      print(e);
    }
    isGettingDetails = false;
    notifyListeners();
  }

  Future<void> searchFacilities(String search, String searchTypeName,
      {List<String>? facilityTypes}) async {
    _isGettingFacInfo = true;
    notifyListeners();

    try {
      _facData = await _searchFacility(
          search: search,
          searchTypeName: searchTypeName,
          facilityTypes: facilityTypes);
      print("Facilities fetched successfully!!!");
    } catch (e) {
      print("Error fetching facilities: $e");
      _facData = [];
    } finally {
      _isGettingFacInfo = false;
      notifyListeners();
    }
  }

  Future<List<Facilities>> _searchFacility({
    String search = "",
    String searchTypeName = "",
    List<String>? facilityTypes,
  }) async {
    HasuraConnect connection = HasuraHelper.hasuraHelper;
    String request = """
      query facilities(\$searchName: String = "%", \$searchTypeName: String = "%", \$facilityTypes: [String!] = []) {
        facilities(where: {
          _and: [
            { name: { _ilike: \$searchName } },
            { facility_type: { name_en: { _ilike: \$searchTypeName } } },
            { facility_type: { type: { _in: \$facilityTypes } } }
          ]
        }) {
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
          image_url
          facility_type {
            name_en
            name_la
            type
            description
          }
        }
      }
    """;

    var data = await connection.query(request, variables: {
      'searchName': search.trim() == "" ? '%%' : '%${search.trim()}%',
      'searchTypeName':
          searchTypeName.trim() == "" ? '%%' : '%${searchTypeName.trim()}%',
      'facilityTypes': facilityTypes ?? ["public", "private", "district"],
    });
    List<dynamic> facilitiesData = data['data']['facilities'];
    return facilitiesData.map((e) => Facilities.fromJson(e)).toList();
  }
}

Future<Facilities> _getOneFacilities({String? id}) async {
  HasuraConnect connection = HasuraHelper.hasuraHelper;
  String request = """
     query fetchEachFac(\$fac_id: uuid! ) {
  facilities(where: {fac_id: {_eq: \$fac_id}}) {
    fac_id
    facility_type {
      name_en
      type
      description
      name_la
    }
    service_details {
      service {
        name_en
        type
      }
    }
    Latitude
    Longitude
    contact_info
    district
    name
    province
    image_url
    rating_count
      village
    status
  }
}
    """;

  var data = await connection.query(request, variables: {
    "fac_id": id,
  });

  return (data['data']['facilities'] as List)
      .map((e) => Facilities.fromJson(e))
      .first;
}
