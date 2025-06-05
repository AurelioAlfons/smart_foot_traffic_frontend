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

// PS C:\Capstone\smart_foot_traffic_frontend> flutter build web --base-href="/smart_foot_traffic_frontend/" --dart-define=API_BASE_URL=https://smart-foot-traffic-backend.onrender.com                                            
// flutter pub global run peanut --release --extra-args="--base-href=/smart_foot_traffic_frontend/" 
// git push origin gh-pages