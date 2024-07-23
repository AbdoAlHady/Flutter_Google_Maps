import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latlng;
  PlaceModel({
    required this.id,
    required this.name,
    required this.latlng,
  });
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: "مطعم ماكدونالدز دمياط",
    latlng: const LatLng(
      31.421503466373963,
      31.80810149531887,
    ),
  ),
  PlaceModel(
    id: 2,
    name:"مطعم الكيلاني",
    latlng: const LatLng(31.4196484199388, 31.81354707695248),
  ),
  PlaceModel(
    id: 3,
    name: "حلواني الجمل - ركن النيل",
    latlng: const LatLng(
     31.417716090912933, 31.811358705372704
    ),
  ),
  PlaceModel(
    id: 4,
    name:"الصفوة مول",
    latlng: const LatLng(
     31.414806884434295, 31.799755761364224
    ),
  ),
];
