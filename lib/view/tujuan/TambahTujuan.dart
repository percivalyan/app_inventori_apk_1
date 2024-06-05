import 'package:app_inventori/Loading.dart';
import 'package:app_inventori/model/TujuanModel.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/view/tujuan/DataTujuan.dart';
import 'package:app_inventori/view/tujuan/EditTujuan.dart';
import 'package:app_inventori/view/tujuan/TambahTujuan.dart';

const List<String> list = <String>['Masuk', 'Keluar'];

class TambahTujuan extends StatefulWidget {
  final VoidCallback reload;
  TambahTujuan(this.reload);
  @override
  State<TambahTujuan> createState() => _TambahTujuanState();
}

class _TambahTujuanState extends State<TambahTujuan> {
  FocusNode myFocusNode = new FocusNode();
  String? Tujuan, Tipe;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      Simpan();
    }
  }

  Simpan() async {
    try {
      final response = await http.post(
          Uri.parse(BaseUrl.urlTambahTujuan.toString()),
          body: {"tujuan": Tujuan, "tipe": Tipe});
      final data = jsonDecode(response.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          widget.reload();
        });
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
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 41, 69, 91),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Tambah Jenis Barang",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              )
            ],
          ),
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Jenis";
                  }
                },
                onSaved: (e) => Tujuan = e,
                decoration: InputDecoration(
                  labelText: 'Tujuan Transaksi',
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 32, 54, 70)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 32, 54, 70)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: Color.fromARGB(255, 32, 54, 70),
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: Tipe,
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            Tipe = value!;
                          });
                        },
                        isExpanded: true,
                        hint: Text(Tipe == null
                            ? "Pilih Tipe Transaksi"
                            : Tipe.toString())),
                  )),
              SizedBox(
                height: 25,
              ),
              MaterialButton(
                color: Color.fromARGB(255, 41, 69, 91),
                onPressed: () {
                  check();
                },
                child: Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              )
            ],
          ),
        ));
  }
}
