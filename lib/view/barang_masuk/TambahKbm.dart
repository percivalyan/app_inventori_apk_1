import 'package:app_inventori/model/KeranjangBmModel.dart';
import 'package:app_inventori/model/TransaksiMasukModel.dart';
import 'package:app_inventori/view/barang/DetailBarang.dart';
import 'package:app_inventori/view/barang/EditBarang.dart';
import 'package:app_inventori/view/barang/TambahBarang.dart';
import 'package:app_inventori/view/barang_masuk/KeranjangBM.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:app_inventori/Loading.dart';
import 'dart:convert';
import 'package:app_inventori/model/BarangModel.dart';
import 'package:app_inventori/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahKbm extends StatefulWidget {
  @override
  State<TambahKbm> createState() => _TambahKbmState();
}

class _TambahKbmState extends State<TambahKbm> {
  FocusNode JmFocusNode = new FocusNode();
  String? IdAdm, Barang, Jumlah;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      IdAdm = pref.getString("id");
    });
  }

  final _key = new GlobalKey<FormState>();
  BarangModel? _currentBR;
  final String? inkBR = BaseUrl.urlDataBarang;
  Future<List<BarangModel>> _fetchBR() async {
    var response = await http.get(Uri.parse(inkBR.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<BarangModel> listOfBR = items.map<BarangModel>((json) {
        return BarangModel.fromJson(json);
      }).toList();
      return listOfBR;
    } else {
      throw Exception('gagal');
    }
  }

  dialogSukses(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
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
            MaterialPageRoute(builder: (context) => new KeranjangBm()));
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

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
          Uri.parse(BaseUrl.urlInputCBM.toString()),
          body: {"barang": Barang, "jumlah": Jumlah, "id": IdAdm});
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
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 41, 69, 91),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Tambah Barang Masuk",
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
              FutureBuilder<List<BarangModel>>(
                future: _fetchBR(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<BarangModel>> snapshot) {
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
                            .map((listBR) => DropdownMenuItem(
                                  child: Text(listBR.nama_barang.toString() +
                                      " ( " +
                                      listBR.nama_brand.toString() +
                                      " )"),
                                  value: listBR,
                                ))
                            .toList(),
                        onChanged: (BarangModel? value) {
                          setState(() {
                            _currentBR = value;
                            Barang = _currentBR!.id_barang;
                          });
                        },
                        isExpanded: true,
                        hint: Text(Barang == null
                            ? "Pilih Barang"
                            : _currentBR!.nama_barang.toString() +
                                " ( " +
                                _currentBR!.nama_brand.toString() +
                                " )"),
                      )));
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Jumlah";
                  }
                },
                onSaved: (e) => Jumlah = e,
                focusNode: JmFocusNode,
                decoration: InputDecoration(
                  labelText: 'Jumlah Barang',
                  labelStyle: TextStyle(
                      color: JmFocusNode.hasFocus
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
