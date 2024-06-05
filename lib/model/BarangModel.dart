class BarangModel {
  String? id_barang;
  String? nama_barang;
  String? nama_jenis;
  String? nama_brand;
  String? foto;
  String? id_jenis;
  String? id_brand;

  BarangModel(this.id_barang, this.nama_barang, this.nama_jenis,
      this.nama_brand, this.foto, this.id_jenis, this.id_brand);

  // Constructor untuk konversi dari JSON
  BarangModel.fromJson(Map<String, dynamic> json) {
    id_barang = json['id_barang'];
    nama_barang = json['nama_barang'];
    nama_jenis = json['nama_jenis'];
    nama_brand = json['nama_brand'];
    foto = json['foto'];
    id_jenis = json['id_jenis'];
    id_brand = json['id_brand'];
  }
}
