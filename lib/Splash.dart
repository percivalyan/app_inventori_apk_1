import 'dart:async';
import 'package:app_inventori/view/Login.dart';
import 'package:app_inventori/view/admin/DataAdmin.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startScreen();
  }

  void startScreen() {
    var duration = const Duration(seconds: 5);
    Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return Login();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FooterView(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/Inventory.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "Inventory Gajah Mada",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
        footer: Footer(
          padding: EdgeInsets.only(bottom: 50),
          backgroundColor: Colors.white,
          child: Text(
            'Copyright ©2024, Inventory Gajah Mada',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.8,
              color: Color(0xFF162A49),
            ),
          ),
        ),
      ),
    );
  }
}
