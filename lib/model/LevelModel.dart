class LevelModel {
  String? id_level;
  String? lvl;

  LevelModel(this.id_level, this.lvl);

  LevelModel.fromJson(Map<String, dynamic> json) {
    id_level = json['id_level'];
    lvl = json['lvl'];
  }
}
