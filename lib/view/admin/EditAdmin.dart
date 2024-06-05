import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:app_inventori/model/AdminModel.dart';
import 'package:app_inventori/model/LevelModel.dart';
import 'package:app_inventori/model/api.dart';

class EditAdmin extends StatefulWidget {
  final VoidCallback reload;
  final AdminModel model;

  EditAdmin(this.model, this.reload);

  @override
  State<EditAdmin> createState() => _EditAdminState();
}

class _EditAdminState extends State<EditAdmin> {
  FocusNode myFocusNode = FocusNode();
  String? id_admin, nama, username, level;
  final _key = GlobalKey<FormState>();
  TextEditingController? txtidAdmin, txtNamaAdmin, txtUsername;

  setup() async {
    txtUsername = TextEditingController(text: widget.model.username);
    txtNamaAdmin = TextEditingController(text: widget.model.nama);
    id_admin = widget.model.id_admin;
  }

  LevelModel? _currentLevel;
  final String? linkLevel = BaseUrl.urlDataLevel;

  Future<List<LevelModel>> _fetchLevel() async {
    var response = await http.get(Uri.parse(linkLevel.toString()));
    print('hasil: ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<LevelModel> listOfLevel = items.map<LevelModel>((json) {
        return LevelModel.fromJson(json);
      }).toList();
      return listOfLevel;
    } else {
      throw Exception('gagal');
    }
  }

  check() {
    final form = _key.currentState;
    if (form != null && form.validate()) {
      form.save();
      ProsesUp();
    }
  }

  ProsesUp() async {
    try {
      final respon = await http.post(Uri.parse(BaseUrl.urlEditAdmin.toString()),
          body: {
            "id_admin": id_admin,
            "nama": nama,
            "username": username,
            "level": level
          });
      final data = jsonDecode(respon.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
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
                "Edit Admin",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtNamaAdmin,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Nama";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nama = e,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
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
            SizedBox(height: 20),
            TextFormField(
              controller: txtUsername,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Username";
                } else {
                  return null;
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 32, 54, 70)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 32, 54, 70)),
                ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<LevelModel>>(
              future: _fetchLevel(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<LevelModel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Container(
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
                      items: snapshot.data!
                          .map((listLevel) => DropdownMenuItem(
                                child: Text(listLevel.lvl.toString()),
                                value: listLevel,
                              ))
                          .toList(),
                      onChanged: (LevelModel? value) {
                        setState(() {
                          _currentLevel = value;
                          level = _currentLevel!.id_level;
                        });
                      },
                      isExpanded: true,
                      hint: Text(level == null || level == widget.model.lvl
                          ? widget.model.lvl.toString()
                          : _currentLevel!.lvl.toString()),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 25),
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
            ),
          ],
        ),
      ),
    );
  }
}
