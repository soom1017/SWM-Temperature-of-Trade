class NewsTileData {
  final int id;
  final String title;
  final String created_at;
  final String? attention_stock;
  final List<String> keywords;

  NewsTileData({
    required this.id,
    required this.title,
    required this.created_at,
    required this.attention_stock,
    required this.keywords,
  });

  factory NewsTileData.fromResponse(Map<String, dynamic> response) {
    final data = response;
    final id = data['id'];
    final title = data['title'];
    final created_at = data['created_at'].toString().substring(data['created_at'].toString().indexOf("T"));
    final attention_stock = data['attention_stock'];
    final keywords = List<String>.from(data['keyword']);

    return NewsTileData(
        id: id,
        title: title,
        created_at: created_at,
        attention_stock: attention_stock,
        keywords: keywords,);
  }
}
