class RankItem {
  String id;
  bool private;
  String belongsTo;
  String parentTitle;
  String description;
  String itemName;
  String picture;
  int rank;

  RankItem(
      {this.id,
      this.belongsTo,
      this.private,
      this.parentTitle,
      this.description,
      this.itemName,
      this.picture,
      this.rank});

  RankItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'][r'$oid'];
    private = json['private'];
    parentTitle = json['parent_title'];
    belongsTo = json['belongs_to'][r'$oid'];
    description = json['description'];
    itemName = json['item_name'];
    picture = json['picture'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.id != null) {
      data['_id'] = this.id;
    }

    data['description'] = this.description;
    data['item_name'] = this.itemName;
    data['picture'] = this.picture;
    data['rank'] = this.rank;
    data['parent_title'] = this.parentTitle;
    data['private'] = this.private;

    return data;
  }
}
