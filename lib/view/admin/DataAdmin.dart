import 'package:app_inventori/Loading.dart';
import 'package:app_inventori/view/admin/EditAdmin.dart';
import 'package:app_inventori/view/admin/TambahAdmin.dart';
// import 'package:app_inventori/view/admin/EditAdmin.dart';
// import 'package:app_inventori/view/admin/TambahAdmin.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_inventori/model/AdminModel.dart';
import 'package:app_inventori/model/api.dart';
import 'package:http/http.dart' as http;

class DataAdmin extends StatefulWidget {
  @override
  State<DataAdmin> createState() => _DataAdminState();
}

class _DataAdminState extends State<DataAdmin> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlDataAdmin));
    if (response.contentLength == 2) {
      setState(() {
        loading = false;
      });
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new AdminModel(
            api['id_admin'], api['nama'], api['username'], api['lvl']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  ProsesHapus(String id) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusAdmin), body: {"id_admin": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    if (value == 1) {
      print(pesan);
      dialogHapus(pesan);
    } else {
      setState(() {
        _lihatData();
      });
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
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Data Admin",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => TambahAdmin(_lihatData))));
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
                              x.nama.toString(),
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditAdmin(x, _lihatData),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                    onPressed: () {
                                      ProsesHapus(x.id_admin);
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
