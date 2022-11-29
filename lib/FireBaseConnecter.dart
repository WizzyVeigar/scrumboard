import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scrumboard/Podo/BoardPost.dart';
import 'package:scrumboard/Podo/BoardPostColumn.dart';

class FireBaseConnector {
  late DatabaseReference dbRef;

  Future<void> SaveAllColumns(List<BoardPostColumn> lists) async {
    dbRef = FirebaseDatabase.instance.ref("data");
    for (var i = 0; i < lists.length; i++) {
      await dbRef.child(i.toString()).set((lists[i]).toJson());
    }
  }

  Future<List<BoardPostColumn>> GetDataBase() async {
    String json = '';
    Object? data;
    dbRef = FirebaseDatabase.instance.ref("data");

    try {
      var snapshot = await dbRef.get();
      if (snapshot.exists) {
        data = snapshot.value;
      }

      List<BoardPostColumn> columns = List.empty(growable: true);
      List<dynamic> dynamics = data as List<dynamic>;

      for (var i = 0; i < dynamics.length; i++) {
        if (dynamics[i] != null) {
          columns.add(BoardPostColumn.fromJson(dynamics[i]));
        }
      }
      return columns;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> UpdateColumnName(int columnIndex, String newName) async {
    dbRef = FirebaseDatabase.instance.ref("data");
    await dbRef.child(columnIndex.toString()).update({'title': newName});
  }

  Future<BoardPost> CreateNewBoardPost(int columnIndex) async {
    dbRef = FirebaseDatabase.instance.ref("data");
    BoardPost post = BoardPost(title: "New Title", from: "New Person");
    Map json = post.toJson();
    int? itemIndex = await GetItemLengthInRow(columnIndex);
    if (itemIndex != null) {
      await dbRef.child("$columnIndex/items/$itemIndex").set(json);
    }
    return post;
  }

  Future<int?> GetItemLengthInRow(int columnIndex) async {
    dbRef = FirebaseDatabase.instance.ref("data");
    int? result;
    await dbRef.child("${columnIndex}/items").get().then((value) {
      List<dynamic> dynamics = value.value as List<dynamic>;
      result = dynamics.length;
    });
    return result;
  }

  Future<void> MovePost(BoardPost item, int oldListIndex, int oldItemIndex,
      int listIndex, int itemIndex) async {
    try {
      dbRef = FirebaseDatabase.instance.ref("data");
      int? result = await GetItemLengthInRow(listIndex);
      await dbRef.child("$oldListIndex/items/$oldItemIndex").remove();
      await dbRef.child("$listIndex/items/$result").set(item.toJson());
      await BubbleSortDb();
    } catch (e) {}
  }

  Future<void> BubbleSortDb() async {
    List<BoardPostColumn> db = await GetDataBase();
    await SaveAllColumns(db);
  }
}
