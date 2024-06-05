class BarangMasukModel {
  String? foto;
  String? nama_barang;
  String? nama_brand;
  String? jumlah_masuk;
  BarangMasukModel(
      this.foto, this.nama_barang, this.nama_brand, this.jumlah_masuk);
  BarangMasukModel.fromJson(Map<String, dynamic> json) {
    foto = json['foto'];
    nama_barang = json['nama_barang'];
    nama_brand = json['nama_brand'];
    jumlah_masuk = json['jumlah_masuk'];
  }
}
