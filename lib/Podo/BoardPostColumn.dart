import 'package:flutter/foundation.dart';
import 'BoardPost.dart';

///Column to hold our tasks / posts
class BoardPostColumn {
  String? title;
  List<BoardPost>? items;

  BoardPostColumn({
    required this.title,
    required this.items,
  });

  factory BoardPostColumn.fromJson(dynamic json) {
    try {
      final title = json['title'];

      List<BoardPost> items = List.empty(growable: true);
      final itemsdata = json['items'] as List<dynamic>?;

      for (var i = 0; i < itemsdata!.length; i++) {
        if (itemsdata[i] != null) items.add(BoardPost.fromJson(itemsdata[i]));
      }
      return BoardPostColumn(title: title, items: items);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BoardPostColumn(title: "Error Column", items: []);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
