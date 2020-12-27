class RankItem {
  int itemId;
  int listId;
  String listTitle;
  bool private;
  int ranking;
  String itemName;
  String description;
  String picture;

  RankItem(
      {this.itemId,
      this.listId,
      this.listTitle,
      this.private,
      this.ranking,
      this.itemName,
      this.description,
      this.picture});

  RankItem.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    listId = json['listId'];
    listTitle = json['listTitle'];
    private = json['private'] == 0 ? false : true;
    ranking = json['ranking'];
    itemName = json['itemName'];
    description = json['description'] == null ? "" : json['description'];
    picture = json['picture'] == null ? "" : json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['listId'] = this.listId;
    data['listTitle'] = this.listTitle;
    data['private'] = this.private;
    data['ranking'] = this.ranking;
    data['itemName'] = this.itemName;
    data['description'] = this.description;
    data['picture'] = this.picture;
    return data;
  }
}
