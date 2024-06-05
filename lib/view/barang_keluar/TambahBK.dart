import 'package:app_inventori/model/TujuanModel.dart';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/view/barang_keluar/DataTransaksiBk.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TambahBK extends StatefulWidget {
  final VoidCallback reload;
  TambahBK(this.reload);
  @override
  State<TambahBK> createState() => _TambahBKState();
}

class _TambahBKState extends State<TambahBK> {
  FocusNode KtFocusNode = new FocusNode();
  String? IdAdm, Tjuan, Ket;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      IdAdm = pref.getString("id");
    });
  }

  final _key = new GlobalKey<FormState>();
  TujuanModel? _currentT;
  final String? linkT = BaseUrl.urlDataTBK;
  Future<List<TujuanModel>> _fetchBR() async {
    var response = await http.get(Uri.parse(linkT.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<TujuanModel> listOfT = items.map<TujuanModel>((json) {
        return TujuanModel.fromJson(json);
      }).toList();
      return listOfT;
    } else {
      throw Exception('gagal');
    }
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      Simpan();
    }
  }

  dialogSukses(String pesan) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Succes',
      desc: pesan,
      btnOkOnPress: () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new DataTransaksiBk()));
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  Simpan() async {
    try {
      final response = await http.post(
          Uri.parse(BaseUrl.urlTambahBk.toString()),
          body: {"tujuan": Tjuan, "ket": Ket, "id": IdAdm});
      final data = jsonDecode(response.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          dialogSukses(pesan);
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
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 41, 69, 91),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Tambah Barang keluar",
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
              FutureBuilder<List<TujuanModel>>(
                future: _fetchBR(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TujuanModel>> snapshot) {
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
                            .map((listT) => DropdownMenuItem(
                                  child: Text(listT.tujuan.toString()),
                                  value: listT,
                                ))
                            .toList(),
                        onChanged: (TujuanModel? value) {
                          setState(() {
                            _currentT = value;
                            Tjuan = _currentT!.id_tujuan;
                          });
                        },
                        isExpanded: true,
                        hint: Text(Tjuan == null
                            ? "Pilih Tujuan transaksi"
                            : _currentT!.tujuan.toString()),
                      )));
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Keterangan";
                  }
                },
                onSaved: (e) => Ket = e,
                focusNode: KtFocusNode,
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                  labelStyle: TextStyle(
                      color: KtFocusNode.hasFocus
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
