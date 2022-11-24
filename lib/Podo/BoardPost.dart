class BoardPost {
  String title;
  String from;

  BoardPost({required this.title, required this.from});

  Map toJson() => {"title": title, "from": from};

  factory BoardPost.fromJson(Map<String, dynamic> json) {
    return BoardPost(title: json['title'], from: json['from']);
  }
}
