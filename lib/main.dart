import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/UI/traffic_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Foot Traffic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TrafficScreen(),
    );
  }
}

// To run the app in web mode, use the following command:
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/* 
cd build/web 
python -m http.server 8080
*/
