import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';

import 'BoardPost.dart';

class BoardPostColumn {
  String title;
  List<BoardPost> items;

  BoardPostColumn({
    required this.title,
    required this.items,
  });

  Map toJson() {
    List<Map>? items =
        this.items != null ? this.items.map((i) => i.toJson()).toList() : null;

    return {
      "title": title,
      "items": items,
    };
  }

  factory BoardPostColumn.fromJson(Map<String, dynamic> json) {
    var dynamics = json['items'] as List;
    print(dynamics.runtimeType);

    List<BoardPost> items = dynamics.map((e) => BoardPost.fromJson(e)).toList();
    return BoardPostColumn(
      title: json['title'],
      items: items,
    );
  }
}
