import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;
  final String? contact;
  final String? type;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.contact,
    this.type,
  });
}

final mapMarkers = [
  MapMarker(
      image: 'assets/images/hospital_1.jpg',
      title: 'Mahosot Central Hospital',
      address: 'Mahosot Road, Vientiane, Laos',
      location: const LatLng(17.960221909533196, 102.61253797152229),
      contact: "20 1234 5678"),
  MapMarker(
      image: 'assets/images/hospital_2.jpg',
      title: 'Setthathirath Hospital',
      address: 'Kaysone Phomvihane Ave, Vientiane, Laos',
      location: const LatLng(17.969946, 102.612465),
      contact: "20 1234 5678"),
  MapMarker(
      image: 'assets/images/hospital_3.jpg',
      title: 'Vientiane Rescue',
      address: 'Ban Nongbone, Thakket Tai, Vientiane, Laos',
      location: const LatLng(17.970935, 102.609987),
      contact: "20 1234 5678"),
  MapMarker(
      image: 'assets/images/hospital_4.jpg',
      title: 'That Luang Marsh Specialized Hospital',
      address: 'That Luang, Vientiane, Laos',
      location: const LatLng(17.978800, 102.634968),
      contact: "20 1234 5678"),
  MapMarker(
    image: 'assets/images/hospital_5.jpg',
    title: 'Mittaphab Hospital',
    address: 'Sokpaluang Road, Vientiane, Laos',
    location: const LatLng(17.968843, 102.595114),
    contact: "20 1234 5678",
  ),
];
