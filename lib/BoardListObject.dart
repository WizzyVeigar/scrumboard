import 'package:boardview/board_list.dart';

class BoardPostColumn {
  String title;
  List<BoardPost> items;

  BoardPostColumn({
    required this.title,
    required this.items,
  });
}

class BoardPost {
  String title;
  String from;

  BoardPost({required this.title, required this.from});
}
