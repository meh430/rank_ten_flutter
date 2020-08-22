class RankItem {
  String id;
  String belongsTo;
  String description;
  String itemName;
  String picture;
  int rank;

  RankItem(
      {this.id,
      this.belongsTo,
      this.description,
      this.itemName,
      this.picture,
      this.rank});

  RankItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'][r'$oid'];
    belongsTo = json['belongs_to'][r'$oid'];
    description = json['description'];
    itemName = json['item_name'];
    picture = json['picture'];
    rank = json['rank'];
  }

/*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['description'] = this.description;
    data['item_name'] = this.itemName;
    data['picture'] = this.picture;
    data['rank'] = this.rank;
    return data;
  }*/
}
