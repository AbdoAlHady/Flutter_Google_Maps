import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class CustomGoogleMaps extends StatefulWidget {
  const CustomGoogleMaps({super.key});

  @override
  State<CustomGoogleMaps> createState() => _CustomGoogleMapsState();
}

class _CustomGoogleMapsState extends State<CustomGoogleMaps> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        target: LatLng(31.418644602574364, 31.81437468209204), zoom: 15);
    initMarkers();

    super.initState();
  }

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
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
    googleMapController.setMapStyle(nightMapStyle);
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
}

// world view 0 -> 3
// country view 4 -> 6
// city view 10 -> 12 
// street view 13 -> 17
// building view 18 -> 20

