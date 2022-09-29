class News {
  List<String> article;
  final String summary;
  List<int> highlight;

  News(this.article, this.summary, this.highlight){
    if (article == null || summary == null || highlight == null) {
      throw ArgumentError("news of News cannot be null. "
          "Received: '$article', '$summary', '$highlight'");
    }
    if (article.isEmpty || summary.isEmpty || highlight.isEmpty) {
      throw ArgumentError("news of News cannot be empty. "
          "Received: '$article', '$summary', '$highlight'");
    }
  }
}