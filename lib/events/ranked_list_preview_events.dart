class RankedListPreviewEvent {
  final int sort;
  final String name;
  final String token;
  final String query;
  final bool refresh;

  RankedListPreviewEvent(
      {this.sort = 0,
      this.name = "",
      this.token = "",
      this.query = "",
      this.refresh = false});
}
