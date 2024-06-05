class AdminModel {
  String? id_admin;
  String? nama;
  String? username;
  String? lvl;

  AdminModel(this.id_admin, this.nama, this.username, this.lvl);

  AdminModel.fromJson(Map<String, dynamic> json) {
    id_admin = json['id_admin'];
    nama = json['nama'];
    username = json['username'];
    lvl = json['lvl'];
  }
}
