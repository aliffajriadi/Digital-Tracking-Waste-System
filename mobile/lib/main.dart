import 'package:flutter/material.dart';
import 'package:mobile/pages/login.dart'; 

void main() {
  runApp(const WasteTrackApp());
}

class WasteTrackApp extends StatelessWidget {
  const WasteTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'WasteTrack',
      theme: ThemeData(
        primarySwatch: Colors.teal, 
      ),
      home: const LoginPage(), 
    );
  }
}