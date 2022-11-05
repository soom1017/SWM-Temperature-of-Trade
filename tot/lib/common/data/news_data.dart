class NewsData {
  final int id;
  final String title;
  final String created_at;
  final String? attention_stock;
  final List<String> keywords;
  final String reporter;
  final String press;
  final List<List<String>> body;
  final String summary;
  final List<int> highlight_idx;
  final int label;
  final double score;

  NewsData({
    required this.id,
    required this.title,
    required this.created_at,
    required this.attention_stock,
    required this.keywords,
    required this.reporter,
    required this.press,
    required this.body,
    required this.summary,
    required this.highlight_idx,
    required this.label,
    required this.score,
  });

  factory NewsData.fromResponse(Map<String, dynamic> response) {
    final data = response['data'];
    final id = data['id'];
    final title = data['title'];
    final created_at = data['created_at'].toString().replaceFirst("T", " ");
    final attention_stock = data['attention_stock'];
    final keywords = List<String>.from(data['keyword']);
    final reporter = data['reporter'];
    final press = data['press'];
    final body = List<List<dynamic>>.from(data['body']).map((e) => e.map((x) => x.toString()).toList()).toList();
    final summary = data['summary'];
    var highlight_idx;
    if(data['highlight_idx'] == null)
      highlight_idx = List<int>.from([]);
    else
      highlight_idx = List<int>.from(data['highlight_idx']);
    final label = data['label'];
    final score = data['score'];

    return NewsData(
        id: id,
        title: title,
        created_at: created_at,
        attention_stock: attention_stock,
        keywords: keywords,
        reporter: reporter,
        press: press,
        body: body,
        summary: summary,
        highlight_idx: highlight_idx,
        label: label,
        score: score);
  }
}
