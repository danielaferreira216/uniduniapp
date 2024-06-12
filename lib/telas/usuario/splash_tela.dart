import 'package:flutter/material.dart';
import 'dart:async';

class SplashTela extends StatefulWidget {
  @override
  _SplashTelaState createState() => _SplashTelaState();
}

class _SplashTelaState extends State<SplashTela> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash_image.jpg'), // Certifique-se de ter uma imagem em assets
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
