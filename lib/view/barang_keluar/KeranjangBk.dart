import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_inventori/model/KeranjangBmModel.dart';
import 'package:app_inventori/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:app_inventori/view/barang_keluar/TambahBK.dart';
import 'package:app_inventori/view/barang_keluar/Tambahkbk.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class KeranjangBK extends StatefulWidget {
  @override
  State<KeranjangBK> createState() => _KeranjangBKState();
}

class _KeranjangBKState extends State<KeranjangBK> {
  String? IdUsr;
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      IdUsr = pref.getString("id");
    });
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response =
        await http.get(Uri.parse(BaseUrl.urlCartBK + IdUsr.toString()));
    if (response.contentLength! > 2) {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = KeranjangBModel(
          api['id_tmp'],
          api['id_barang'],
          api['foto'],
          api['nama_barang'],
          api['nama_brand'],
          api['jumlah'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _proseshapus(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.urlDeleteCBK), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      _lihatData();
    } else {
      print(pesan);
      dialogHapus(pesan);
    }
  }

  dialogHapus(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'ERROR',
      desc: pesan,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Keranjang Barang Keluar",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Tambahkbk()));
        },
        child: FaIcon(FontAwesomeIcons.plus),
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            width: double.infinity,
            child: MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Tambahkbk()));
              },
              child: Text(
                "Tambah",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: RefreshIndicator(
              onRefresh: _lihatData,
              key: _refresh,
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Container(
                          margin: EdgeInsets.all(5),
                          child: Card(
                            color: const Color.fromARGB(255, 250, 248, 246),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 64,
                                      minHeight: 64,
                                      maxWidth: 84,
                                      maxHeight: 84,
                                    ),
                                    child: Image.network(
                                      BaseUrl.path + x.foto.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ID: " + x.id_barang.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Divider(color: Colors.transparent),
                                      Text(
                                        x.nama_barang.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Divider(color: Colors.transparent),
                                      Text(
                                        "Brand: " + x.nama_brand.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Divider(color: Colors.transparent),
                                      Text(
                                        "Jumlah: " + x.jumlah.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Divider(color: Colors.transparent),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      _proseshapus(x.id_tmp);
                                    },
                                    icon: FaIcon(FontAwesomeIcons.trash,
                                        size: 20, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.all(5),
            width: double.infinity,
            child: loading
                ? Text("")
                : MaterialButton(
                    color: Color.fromARGB(255, 41, 69, 91),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TambahBK(_lihatData)));
                    },
                    child: Text(
                      "Proses data",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
          ),
        ],
      ),
    );
  }
}
