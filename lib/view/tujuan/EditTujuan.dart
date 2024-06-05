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

class EditTujuan extends StatefulWidget {
  final VoidCallback reload;
  final TujuanModel model;
  EditTujuan(this.model, this.reload);
  @override
  State<EditTujuan> createState() => _EditTujuanState();
}

class _EditTujuanState extends State<EditTujuan> {
  FocusNode myFocusNode = new FocusNode();
  String? id_tujuan, Tujuan, Tipe, T7an;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtTujuan;
  setup() async {
    T7an = widget.model.tipe;
    if (T7an == "M") {
      T7an = "Masuk";
    } else if (T7an == "K") {
      T7an = "Keluar";
    }
    txtTujuan = TextEditingController(text: widget.model.tujuan);
    id_tujuan = widget.model.id_tujuan;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      UpdateTujuan();
    }
  }

  UpdateTujuan() async {
    try {
      final respon = await http.post(
          Uri.parse(BaseUrl.urlEditTujuan.toString()),
          body: {"id_tujuan": id_tujuan, "tujuan": Tujuan, "tipe": Tipe});
      final data = jsonDecode(respon.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          // widget.reload;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new DataTujuan()));
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
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
                "Edit Tujuan Transaksi",
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
              controller: txtTujuan,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Tujuan";
                } else {
                  return null;
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
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 32, 54, 70)),
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
                      items: list.map<DropdownMenuItem<String>>((String value) {
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
                      hint: Text(
                          Tipe == null ? T7an.toString() : Tipe.toString())),
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
                "Edit",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            )
          ],
        ),
      ),
    );
  }
}
