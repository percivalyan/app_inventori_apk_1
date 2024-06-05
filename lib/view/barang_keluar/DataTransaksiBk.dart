import 'package:flutter/material.dart';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/model/TransaksiMasukModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:app_inventori/Loading.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:app_inventori/view/barang_keluar/DetailTbk.dart';
import 'package:app_inventori/view/barang_keluar/KeranjangBk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataTransaksiBk extends StatefulWidget {
  @override
  State<DataTransaksiBk> createState() => _DataTransaksiBkState();
}

class _DataTransaksiBkState extends State<DataTransaksiBk> {
  var loading = false;
  String? LvlUsr;
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
      LvlUsr = pref.getString("level");
    });
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlTransaksiBK));
    if (response.contentLength! > 2) {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = TransaksiMasukModel(
          api['id_transaksi'],
          api['tujuan'],
          api['total_item'],
          api['tgl_transaksi'],
          api['keterangan'],
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
        await http.post(Uri.parse(BaseUrl.urlHapusBK), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      _lihatData();
      setState(() {});
    } else {
      print(pesan);
      dialogHapus(pesan);
    }
  }

  alertHapus(String id) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      animType: AnimType.topSlide,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      showCloseIcon: true,
      closeIcon: const Icon(Icons.close_fullscreen_outlined),
      title: 'WARNING!!',
      desc:
          'Menghapus data ini akan mengembalikan stok seperti sebelum barang ini di input, Yakin Hapus??',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        _proseshapus(id);
      },
    ).show();
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
                "Data Transaksi Barang Keluar",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => KeranjangBK()));
        },
        child: FaIcon(FontAwesomeIcons.cartPlus),
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
      ),
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: _lihatData,
        child: loading
            ? Loading()
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Card(
                      color: const Color.fromARGB(255, 250, 248, 246),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(x.id_transaksi.toString()),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total: ${x.total_item.toString()}"),
                                SizedBox(width: 5),
                                Text("(${x.tgl_transaksi.toString()})"),
                              ],
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailTbk(x, _lihatData)));
                                  },
                                  icon: FaIcon(FontAwesomeIcons.eye, size: 20),
                                ),
                                if (LvlUsr == "1")
                                  IconButton(
                                    onPressed: () {
                                      alertHapus(x.id_transaksi);
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.trash,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
