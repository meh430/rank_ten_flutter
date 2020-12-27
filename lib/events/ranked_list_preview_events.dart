class RankedListPreviewEvent {
  final int sort, userId;
  final String token;
  final String query;
  final bool refresh;

  RankedListPreviewEvent(
      {this.sort = 0,
      this.userId = 0,
      this.token = "",
      this.query = "",
      this.refresh = false});
}
