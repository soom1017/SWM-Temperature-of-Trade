class NewsTileData {
  final int id;
  final int label;
  final String title;
  final String created_at;
  final String summary;
  final String? attention_stock;
  final List<String> keywords;

  NewsTileData({
    required this.id,
    required this.title,
    required this.created_at,
    required this.summary,
    required this.attention_stock,
    required this.keywords,
    required this.label,
  });

  factory NewsTileData.fromResponse(Map<String, dynamic> response) {
    final data = response;
    final id = data['id'];
    final title = data['title'];
    final created_at = data['created_at'].toString().substring(0, data['created_at'].toString().indexOf("T"));
    final summary = data['summary'];
    final attention_stock = data['attention_stock'];
    final keywords = List<String>.from(data['keyword']);
    final label = data['label'];

    return NewsTileData(
        id: id,
        title: title,
        created_at: created_at,
        summary: summary,
        attention_stock: attention_stock,
        keywords: keywords,
        label:label,);
  }
}
