import 'package:latlong2/latlong.dart';

class AppConstants {
  static const String urlTemplate = "https://api.mapbox.com/styles/v1/shokoon/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}";
  static const String mapBoxAccessToken =
      'pk.eyJ1Ijoic2hva29vbiIsImEiOiJjbHF4bTVhaTcwZmdrMmpwbnQ3b2FuOGZjIn0.LVhMtRulH3CH7Rhv-z6gFg';

  static const String mapBoxStyleId = 'clrkgfe35001k01o30vhh774o';
  static const myLocation = LatLng(17.970557060788902, 102.61239019721894);
}
