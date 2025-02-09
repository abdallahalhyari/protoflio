import 'package:flutter/material.dart';
import 'package:profile/module/home/home_screen.dart';

void main() => runApp(PortfolioApp());

class PortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abdallah Alhyari - Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.grey[700]),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

