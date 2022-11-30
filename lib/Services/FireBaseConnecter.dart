import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:scrumboard/Podo/BoardPost.dart';
import 'package:scrumboard/Podo/BoardPostColumn.dart';

class FireBaseConnector {
  late DatabaseReference dbRef;

  //Save a List of columns to the root of the realtime database
  Future<void> SaveAllColumns(List<BoardPostColumn> lists) async {
    dbRef = FirebaseDatabase.instance.ref("data");
    for (var i = 0; i < lists.length; i++) {
      await dbRef.child(i.toString()).set((lists[i]).toJson());
    }
  }

  ///Gets all columns and their values from the realtime database
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
      //We turn it into a list of dynamic, because our fromJson methods can convert it from dynamics
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

  ///Update the name of a clicked column
  Future<void> UpdateColumnName(int columnIndex, String newName) async {
    dbRef = FirebaseDatabase.instance.ref("data");
    await dbRef.child(columnIndex.toString()).update({'title': newName});
  }

  ///Creates a new post in a designated column
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

  ///Gets the length of a column, by an index
  Future<int?> GetItemLengthInRow(int columnIndex) async {
    dbRef = FirebaseDatabase.instance.ref("data");
    int? result;
    await dbRef.child("${columnIndex}/items").get().then((value) {
      List<dynamic> dynamics = value.value as List<dynamic>;
      result = dynamics.length;
    });
    return result;
  }

  ///Move a post from one position to another
  Future<void> MovePost(BoardPost item, int oldListIndex, int oldItemIndex,
      int listIndex, int itemIndex) async {
    try {
      dbRef = FirebaseDatabase.instance.ref("data");
      int? result = await GetItemLengthInRow(listIndex);
      await dbRef.child("$oldListIndex/items/$oldItemIndex").remove();
      await dbRef.child("$listIndex/items/$result").set(item.toJson());

      await RefreshDbValues();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  ///Refreshes all the elements in the db, as to not skip any values because of deletion/updates
  Future<void> RefreshDbValues() async {
    List<BoardPostColumn> db = await GetDataBase();
    await SaveAllColumns(db);
  }
}
