import 'package:flutter/material.dart';
import 'package:flutter_google_maps/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  void initMarkers() async{
    var customMarkerIcon = await BitmapDescriptor.asset(const ImageConfiguration(), 'assets/images/location_marker.png');
    var myMarkers = places
        .map((place) => Marker(
          icon: customMarkerIcon,
              markerId: MarkerId(place.id.toString()),
              position: place.latlng,
              infoWindow: InfoWindow(title: place.name),
            ))
        .toSet();

    markers.addAll(myMarkers);
    setState(() {
      
    });
  }
}

// world view 0 -> 3
// country view 4 -> 6
// city view 10 -> 12 
// street view 13 -> 17
// building view 18 -> 20

