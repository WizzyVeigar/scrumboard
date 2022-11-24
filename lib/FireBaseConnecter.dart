import 'dart:convert';

import 'package:boardview/boardview.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scrumboard/Podo/BoardPost.dart';
import 'package:scrumboard/Podo/BoardPostColumn.dart';

class FireBaseConnector {
  late DatabaseReference dbRef;

  Future<void> SaveAllColumns(List<BoardPostColumn> lists) async {
    dbRef = FirebaseDatabase.instance.ref();
    String json = jsonEncode(lists);
    print("DOES THIS LOOK GOOD?" + json);
    await dbRef.set(json);
  }

  Future<List<BoardPostColumn>> GetDataBase() async {
    String json = '';
    dbRef = FirebaseDatabase.instance.ref();
    final snapshot = await dbRef.get();
    print('DO I REACH THIS');
    // print('SNAPSHOT DATA: ${snapshot.value}');
    // print('SNAPSHOT EXISTS?: ${snapshot.exists}');
    if (snapshot.exists) {
      json = snapshot.value.toString();

      // print("JSON: ${json}");
    }

    List<dynamic> something = jsonDecode(json);
    print('THIS IS ' + something.toString());

    print('A DYNAMIC ' + something[0].toString());
    List<BoardPostColumn> columns = List.empty(growable: true);
    print('HOW MUCH IN THIS BITCH?: ' + something.length.toString());

    try {
      for (var i = 0; i < something.length; i++) {
        print('Hello' + i.toString());

        columns.add(BoardPostColumn.fromJson(something[i]));
        print('Added to SOMETHING');
      }
    } catch (e) {
      print(e);
    }

    // List<BoardPostColumn> sds =
    //     something.map((column) => BoardPostColumn.fromJson(column)).toList();

    // print('THIS IS AFTER ' + sds.length.toString());
    print('Hi? ' + columns.length.toString());
    return columns;
  }
}
