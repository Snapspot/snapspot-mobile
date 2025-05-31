import 'package:flutter/material.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapSpot App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
