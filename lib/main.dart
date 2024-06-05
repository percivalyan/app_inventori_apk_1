import 'package:app_inventori/Splash.dart';
import 'package:app_inventori/view/admin/DataAdmin.dart';
import 'package:app_inventori/view/jenis/DataJenis.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
    // home: DataJenis(),
    // home: DataAdmin(),
    home: Splash(),
  ));
}
