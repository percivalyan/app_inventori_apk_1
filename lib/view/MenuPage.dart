import 'dart:convert';
import 'package:app_inventori/view/barang/DataBarang.dart';
import 'package:app_inventori/view/barang_keluar/DataTransaksiBk.dart';
import 'package:app_inventori/view/barang_masuk/DataTransaksi.dart';
import 'package:app_inventori/view/brand/DataBrand.dart';
import 'package:app_inventori/view/tujuan/DataTujuan.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/model/CountData.dart';
import 'package:app_inventori/view/admin/DataAdmin.dart';
import 'package:app_inventori/view/jenis/DataJenis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MenuPage extends StatefulWidget {
  final VoidCallback LogOut;
  MenuPage(this.LogOut);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  FocusNode myFocusNode = FocusNode();
  String? IdUsr, LvlUsr, NamaUsr;
  bool _MDTileExpanded = false;
  bool _LpTileExpanded = false;
  bool _TsTileExpanded = false;

  // @override
  // void initState() {
  //   super.initState();
  //   getPref();
  // }

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      IdUsr = pref.getString("id");
      NamaUsr = pref.getString("nama");
      LvlUsr = pref.getString("level");
    });
  }

  void LogOut() {
    setState(() {
      widget.LogOut();
    });
  }

  var loading = false;
  String Stl = "0";
  String Sbm = "0";
  String Sbk = "0";
  final List<CountData> ex = [];

  _countBR() async {
    setState(() {
      loading = true;
    });
    ex.clear();
    final response = await http.get(Uri.parse(BaseUrl.urlCount));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = CountData(api['stok'], api['jm'], api['jk']);
      ex.add(exp);
      setState(() {
        Stl = exp.stok.toString();
        Sbm = exp.jm.toString();
        Sbk = exp.jk.toString();
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _countBR();
  }

  void infoOut() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: true,
      animType: AnimType.bottomSlide,
      title: 'Ready to Leave?',
      desc:
          'Select "Logout" below if you are ready to end your current session.',
      btnOkText: 'Logout',
      reverseBtnOrder: true,
      btnOkOnPress: () {
        LogOut();
      },
      btnCancelOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Text(
          'INVENTORI',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
            color: Colors.white), // This sets the hamburger menu icon to white
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Card(
              color: Color.fromARGB(255, 250, 248, 246),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Color.fromARGB(255, 160, 238, 206),
                        width: 5,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Total Barang Masuk",
                          style: TextStyle(
                            color: Color.fromARGB(255, 23, 33, 41),
                          ),
                        ),
                        subtitle: Sbm == "null"
                            ? Text(
                                "0",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                Sbm,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        trailing: Icon(
                          FontAwesomeIcons.box,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Card(
              color: Color.fromARGB(255, 250, 248, 246),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Color.fromARGB(255, 142, 156, 221),
                        width: 5,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Total Stok Barang",
                          style: TextStyle(
                            color: Color.fromARGB(255, 23, 33, 41),
                          ),
                        ),
                        subtitle: Stl.toString() == "null"
                            ? Text(
                                "0",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                Stl,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        trailing: Icon(
                          FontAwesomeIcons.boxesStacked,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Card(
              color: Color.fromARGB(255, 250, 248, 246),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Color.fromARGB(255, 142, 156, 221),
                        width: 5,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Total Stok Barang",
                          style: TextStyle(
                            color: Color.fromARGB(255, 23, 33, 41),
                          ),
                        ),
                        subtitle: Stl.toString() == "null"
                            ? Text(
                                "0",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                Stl,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        trailing: Icon(
                          FontAwesomeIcons.boxesStacked,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(NamaUsr ?? ''),
              accountEmail: LvlUsr == "1" ? Text("Super Admin") : Text("Admin"),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: AssetImage("assets/Inventory.png"),
                backgroundColor: Color.fromARGB(255, 41, 69, 91),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profil"),
              onTap: () {},
            ),
            Divider(height: 25, thickness: 1),
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: FaIcon(
                  FontAwesomeIcons.database,
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : Color.fromARGB(255, 119, 120, 121),
                ),
                title: Text(
                  "Master Data",
                  style: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 51, 53, 54),
                  ),
                ),
                trailing: FaIcon(
                  _MDTileExpanded
                      ? FontAwesomeIcons.chevronDown
                      : FontAwesomeIcons.chevronRight,
                  size: 15,
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : Color.fromARGB(255, 119, 120, 121),
                ),
                children: [
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Jenis"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataJenis()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Brand"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataBrand()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Barang"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataBarang()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Tujuan"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataTujuan()),
                      );
                    },
                  ),
                  if (LvlUsr == "1")
                    ListTile(
                      leading: Text(""),
                      title: Text("Data Admin"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DataAdmin()),
                        );
                      },
                    ),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() => _MDTileExpanded = expanded);
                },
              ),
            ),
            Divider(height: 25, thickness: 1),
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: FaIcon(
                  FontAwesomeIcons.exchange,
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : Color.fromARGB(255, 119, 120, 121),
                ),
                title: Text(
                  "Transaksi",
                  style: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 51, 53, 54),
                  ),
                ),
                trailing: FaIcon(
                  _TsTileExpanded
                      ? FontAwesomeIcons.chevronDown
                      : FontAwesomeIcons.chevronRight,
                  size: 15,
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : Color.fromARGB(255, 119, 120, 121),
                ),
                children: [
                  ListTile(
                    leading: Text(""),
                    title: Text("Barang Masuk"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DataTransaksi()));
                    },
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Barang Keluar"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DataTransaksiBk()));
                    },
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() => _TsTileExpanded = expanded);
                },
              ),
            ),
            Divider(height: 25, thickness: 1),
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: FaIcon(
                  FontAwesomeIcons.clipboardList,
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : Color.fromARGB(255, 119, 120, 121),
                ),
                title: Text(
                  "Laporan",
                  style: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 51, 53, 54),
                  ),
                ),
                trailing: FaIcon(
                  _LpTileExpanded
                      ? FontAwesomeIcons.chevronDown
                      : FontAwesomeIcons.chevronRight,
                  size: 15,
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : Color.fromARGB(255, 119, 120, 121),
                ),
                children: [
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Stok"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Laporan Barang Masuk"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Laporan Barang Keluar"),
                    onTap: () {},
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() => _LpTileExpanded = expanded);
                },
              ),
            ),
            Divider(height: 25, thickness: 1),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () => infoOut(),
            ),
          ],
        ),
      ),
      drawerEnableOpenDragGesture: false,
    );
  }
}
