import 'package:app_inventori/Loading.dart';
import 'package:app_inventori/view/jenis/EditJenis.dart';
import 'package:app_inventori/view/jenis/TambahJenis.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_inventori/model/JenisModel.dart';
// import 'package:app_inventori/model/TambahJenis.dart';
import 'package:app_inventori/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:async/async.dart';

class DataJenis extends StatefulWidget {
  @override
  State<DataJenis> createState() => _DataJenisState();
}

class _DataJenisState extends State<DataJenis> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  // Dari tutorial kode asli
  // Future<void> _lihatData() async {
  //   list.clear();
  //   setState(() {
  //     loading = true;
  //   });
  //   final response = await http.get(Uri.parse(BaseUrl.urlDataJenis));
  //   if (response.contentLength == 2) {
  //   } else {
  //     final data = jsonDecode(response.body);
  //     data.forEach((api) {
  //       final ab = new JenisModel(api['id_jenis'], api['nama_jenis']);
  //       list.add(ab);
  //     });
  //     setState(() {
  //       loading = true;
  //     });
  //   }
  // }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlDataJenis));
    if (response.contentLength == 2) {
      setState(() {
        loading = false; // Set loading to false if no data is received
      });
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new JenisModel(api['id_jenis'], api['nama_jenis']);
        list.add(ab);
      });
      setState(() {
        loading = false; // Set loading to false after data is loaded
      });
    }
  }

  // Mengubah koneksi dari tutorial
  // Future<void> _lihatData() async {
  //   list.clear();
  //   setState(() {
  //     loading = true;
  //   });
  //   try {
  //     final response = await http.get(Uri.parse(BaseUrl.urlDataJenis));
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       data.forEach((api) {
  //         final ab = new JenisModel(api['id_jenis'], api['nama_jenis']);
  //         list.add(ab);
  //       });
  //       setState(() {
  //         loading = false; // Perubahan disini
  //       });
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     setState(() {
  //       loading = false;
  //     });
  //     print('Error: $e');
  //     // Tambahkan penanganan error sesuai kebutuhan aplikasi Anda.
  //   }
  // }

  ProsesHapus(String id) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusJenis), body: {"id_jenis": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    // Terbalik
    if (value == 1) {
      print(pesan);
      dialogHapus(pesan);
    } else {
      setState(() {
        _lihatData();
      });
      // Tampilkan pesan peringatan menggunakan metode lain
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dihapus')),
      );
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
  void initState() {
    super.initState();
    getPref();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //Mematikan tombol back bagian atas
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Stock Jenis Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //print("tambah jenis");
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => TambahJenis())));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
      ),
      body: RefreshIndicator(
          onRefresh: _lihatData,
          key: _refresh,
          child: loading
              ? Loading()
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Container(
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              x.nama_jenis.toString(),
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    //edit
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditJenis(x, _lihatData),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                    onPressed: () {
                                      //delete
                                      ProsesHapus(x.id_jenis);
                                    },
                                    icon: Icon(Icons.delete)),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )),
    );
  }
}
