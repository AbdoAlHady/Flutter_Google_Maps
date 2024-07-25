import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps/models/place_model.dart';
import 'package:flutter_google_maps/service/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:location_platform_interface/location_platform_interface.dart';

class CustomGoogleMaps extends StatefulWidget {
  const CustomGoogleMaps({super.key});

  @override
  State<CustomGoogleMaps> createState() => _CustomGoogleMapsState();
}

class _CustomGoogleMapsState extends State<CustomGoogleMaps> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
  bool isFirstCall = true;
  late LocationService locationService;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        target: LatLng(31.418644602574364, 31.81437468209204), zoom: 1);
    // initMarkers();
    // initPolyliens();
    // initPolygon();
    // initCircle();
    locationService = LocationService();
    updateMyLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      polylines: polylines,
      polygons: polygons,
      zoomControlsEnabled: false,
      circles: circles,
      markers: markers,
      onMapCreated: (controller) {
        googleMapController = controller;
        initMapStyle();
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  void initMapStyle() async {
    // Load Json File
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');
    googleMapController!.setMapStyle(nightMapStyle);
  }

  Future<Uint8List> getImageFormRawData(String image, double width) async {
    var imageData = await rootBundle.load(image); // load raw data
    var imageCodec = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
        targetWidth: width.round());
    var imageFrame = await imageCodec.getNextFrame();
    var imageByteData =
        await imageFrame.image.toByteData(format: ui.ImageByteFormat.png);
    return imageByteData!.buffer.asUint8List();
  }

  void initMarkers() async {
    var customMarkerIcon = BitmapDescriptor.bytes(
        await getImageFormRawData('assets/images/location_marker.png', 50));
    var myMarkers = places
        .map((place) => Marker(
              icon: customMarkerIcon,
              markerId: MarkerId(place.id.toString()),
              position: place.latlng,
              infoWindow: InfoWindow(title: place.name),
            ))
        .toSet();

    markers.addAll(myMarkers);
    setState(() {});
  }

  void initPolyliens() {
    Polyline polyline = const Polyline(
      polylineId: PolylineId('1'),
      width: 5,
      startCap: Cap.roundCap,
      color: Colors.red,
      patterns: [PatternItem.dot],
      zIndex: 2,
      points: [
        LatLng(31.403850098063895, 31.792834567369113),
        LatLng(31.408481297231642, 31.796273682794133),
        LatLng(31.40169749107413, 31.80001849736805),
        LatLng(31.393206925193066, 31.80972715051236),
      ],
    );

    Polyline polyline2 = const Polyline(
      polylineId: PolylineId('1'),
      width: 5,
      startCap: Cap.roundCap,
      color: Colors.black,
      zIndex: 1,
      points: [
        LatLng(31.39871116531892, 31.783282792951155),
        LatLng(31.41237098972474, 31.814582067904848),
      ],
    );

    polylines.add(polyline);
    polylines.add(polyline2);
  }

  void initPolygon() {
    Polygon polygon = Polygon(
        polygonId: const PolygonId('1'),
        fillColor: Colors.black.withOpacity(0.5),
        strokeWidth: 3,
        points: const [
          LatLng(31.44549803112866, 31.715613184933257),
          LatLng(31.47815083004072, 31.747713859572805),
          LatLng(31.458091939181017, 31.75990181625412),
          LatLng(31.42792230701503, 31.751662070892106),
        ]);
    polygons.add(polygon);
  }

  void initCircle() {
    Circle carStation = Circle(
      circleId: CircleId('1'),
      fillColor: Colors.black.withOpacity(0.5),
      radius: 5000,
      center: const LatLng(31.428319766693185, 31.64538763039289),
    );

    circles.add(carStation);
  }

  void updateMyLocation() async {
    await locationService.checkAndRequestLocationService();
    var hasPremission =
        await locationService.checkAndRequestLocationPermission();
    if (hasPremission) {
      locationService.getRealTimeLocationData(
        (locationData) {
          _setMyCameraPosition(locationData);
          _addMarkerToMyLocation(locationData);
        },
      );
    }
  }

  void _addMarkerToMyLocation(LocationData locationData) {
    var myLocationMarker = Marker(
      markerId: const MarkerId('My_Location_Marker'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
    );
    markers.add(myLocationMarker);
    setState(() {});
  }

  void _setMyCameraPosition(LocationData locationData) {
    if (isFirstCall) {
      var cameraPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 17,
      );
      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      isFirstCall = false;
    } else {
      googleMapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    }
  }
}

// world view 0 -> 3
// country view 4 -> 6
// city view 10 -> 12 
// street view 13 -> 17
// building view 18 -> 20

