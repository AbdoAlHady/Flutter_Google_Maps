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
    initPolyliens(); 

    super.initState();
  }

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      polylines: polylines,
      zoomControlsEnabled: false,
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
}

// world view 0 -> 3
// country view 4 -> 6
// city view 10 -> 12 
// street view 13 -> 17
// building view 18 -> 20

