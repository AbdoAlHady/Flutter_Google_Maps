import 'package:flutter/material.dart';
import 'package:flutter_google_maps/widgets/custom_google_maps.dart';

void main() {
  runApp(const TestGoogleMapWithFlutter());
}

class TestGoogleMapWithFlutter extends StatelessWidget {
  const TestGoogleMapWithFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:CustomGoogleMaps() ,
    );
  }
}