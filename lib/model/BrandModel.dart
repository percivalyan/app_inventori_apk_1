class BrandModel {
  String? id_brand;
  String? nama_brand;

  BrandModel(this.id_brand, this.nama_brand);

  BrandModel.fromJson(Map<String, dynamic> json) {
    id_brand = json['id_brand'];
    nama_brand = json['nama_brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_brand'] = this.id_brand;
    data['nama_brand'] = this.nama_brand;
    return data;
  }
}
