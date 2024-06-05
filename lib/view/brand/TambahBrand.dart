import 'package:app_inventori/view/brand/DataBrand.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_inventori/model/api.dart';
import 'package:http/http.dart' as http;

class TambahBrand extends StatefulWidget {
  @override
  State<TambahBrand> createState() => _TambahBrandState();
}

class _TambahBrandState extends State<TambahBrand> {
  String? brand;
  final _key = GlobalKey<FormState>();

  void check() {
    final form = _key.currentState;
    if (form != null && form.validate()) {
      form.save();
      simpanBrand();
    }
  }

  Future<void> simpanBrand() async {
    try {
      final response = await http.post(
          Uri.parse(BaseUrl.urlTambahBrand.toString()),
          body: {"brand": brand!});
      final data = jsonDecode(response.body);
      int code = data['success'];
      String pesan = data['message'];
      if (code == 1) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DataBrand()));
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 62, 78),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Text(
          "Tambah Brand Barang",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Silakan isi Brand";
                }
                return null;
              },
              onSaved: (value) => brand = value,
              decoration: InputDecoration(
                labelText: 'Brand Barang',
                labelStyle: TextStyle(
                  color: Colors.blue,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 32, 54, 70),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: check,
              child: Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
