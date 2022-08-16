class NewsApiModel {
  String title, imageUrl, content, description;

  NewsApiModel(
      {this.title,
      this.description,
      this.content,
      this.imageUrl});

  factory NewsApiModel.fromJson(Map<String, dynamic> jsonData) {
    return NewsApiModel(
      title: jsonData['title'] ?? "",
      description: jsonData['description'] ?? "",
      content: jsonData['content'] ?? "",
      imageUrl: jsonData['urlToImage'] ?? "",
    );
  }
}
