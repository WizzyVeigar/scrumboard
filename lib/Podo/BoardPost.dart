///A task in our board
class BoardPost {
  String? title;
  String? from;

  BoardPost({required this.title, required this.from});

  factory BoardPost.fromJson(dynamic json) {
    final title = json['title'];
    final from = json['from'];
    return BoardPost(title: title, from: from);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['from'] = from;
    return data;
  }
}
