import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrumboard/Services/FireBaseConnecter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scrumboard/firebase_options.dart';

import '../Podo/BoardPost.dart';
import '../Podo/BoardPostColumn.dart';

class ScrumBoardScreen extends StatefulWidget {
  ScrumBoardScreen({super.key});

  @override
  State<ScrumBoardScreen> createState() => _ScrumBoardScreenState();
}

class _ScrumBoardScreenState extends State<ScrumBoardScreen> {
  late List<BoardPostColumn> dbData;
  late FireBaseConnector connector;
  List<BoardPostColumn> testData = [
    //In here you map the data to your Scrum board
    BoardPostColumn(title: 'To Do', items: [
      BoardPost(title: 'Data', from: 'Person1'),
      BoardPost(title: 'Data2', from: 'Person2')
    ]),
    BoardPostColumn(title: 'Ongoing', items: [
      BoardPost(title: 'Data', from: 'Person1'),
      BoardPost(title: 'Data2', from: 'Person2')
    ]),
    BoardPostColumn(title: 'Backburner', items: [
      BoardPost(title: 'Data', from: 'Person1'),
      BoardPost(title: 'Data2', from: 'Person2')
    ]),
    BoardPostColumn(title: 'Done', items: [
      BoardPost(title: 'Data', from: 'Person1'),
      BoardPost(title: 'Data', from: 'Person2'),
      BoardPost(title: 'Data', from: 'Person3'),
      BoardPost(title: 'Data', from: 'Person4'),
      BoardPost(title: 'Data2', from: 'Person5')
    ])
  ];

  late BoardViewController boardViewController;
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();

    boardViewController = BoardViewController();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDatabase(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BoardList> lists = [];
          for (int i = 0; i < dbData.length; i++) {
            lists.add(createBoardList(dbData[i], context));
          }
          return BoardView(
            lists: lists,
            boardViewController: boardViewController,
          );
        }
        return Center(child: const CircularProgressIndicator());
      },
    );
  }

  ///Creates a [BoardList] with drag n drop functionality
  BoardList createBoardList(BoardPostColumn list, BuildContext context) {
    List<BoardItem> items = [];
    for (BoardPost element in list.items!) {
      // if (kDebugMode) {
      //   print('List: ${list.title} item: ${element.from}');
      // }
    }

    for (int i = 0; i < list.items!.length; i++) {
      items.insert(i, buildBoardItem(list.items![i], context));
    }

    return BoardList(
      onStartDragList: (int? listIndex) {},
      //OnTap for each individual task, open an edit dialog box
      onTapList: (int? listIndex) async {
        final inputText = await openEditColumnNameDialog(listIndex!);
        if (inputText == null || inputText.isEmpty) return;
        setState(() => dbData[listIndex].title = inputText);
      },
      onDropList: (int? listIndex, int? oldListIndex) {
        //Update our local list data
        var list = dbData[oldListIndex!];
        dbData.removeAt(oldListIndex);
        dbData.insert(listIndex!, list);
      },
      headerBackgroundColor: const Color(0xFFEBECF0),
      backgroundColor: const Color(0xFFEBECF0),
      header: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      list.title!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Card(
                      elevation: 1,
                      child: IconButton(
                          mouseCursor: SystemMouseCursors.click,
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: (() async {
                            createNewBoardPost(list);
                          }),
                          icon: const Icon(Icons.add_outlined)),
                    )
                  ],
                ))),
      ],
      items: items,
    );
  }

  ///Creates each individuel [BoardItem] of time [BoardPost] that will be used in the [BoardList]
  BoardItem buildBoardItem(BoardPost itemObject, BuildContext context) {
    return BoardItem(
        onStartDragItem:
            (int? listIndex, int? itemIndex, BoardItemState? state) {},
        onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
            int? oldItemIndex, BoardItemState? state) {
          //Used to update our local item data
          if (listIndex != oldListIndex || itemIndex != oldItemIndex) {
            var item = dbData[oldListIndex!].items![oldItemIndex!];
            dbData[oldListIndex].items!.removeAt(oldItemIndex);
            dbData[listIndex!].items!.insert(itemIndex!, item);
            connector.MovePost(
                item, oldListIndex, oldItemIndex, listIndex, itemIndex);
          }
        },
        //Holder for tasks, use ontap to rename the thingy
        onTapItem:
            (int? listIndex, int? itemIndex, BoardItemState? state) async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(dbData[listIndex!].items![itemIndex!].title!),
                  content: Text('This is a text ${itemIndex + 1}'),
                );
              });
        },
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemObject.title!),
          ),
        ));
  }

  Future<String?> openEditColumnNameDialog(int listIndex) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(dbData[listIndex].title!),
          actions: [
            TextButton(
              onPressed: (() {
                updateColumnName(listIndex);
              }),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
          content: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      autofocus: true,
                      onSubmitted: (value) => updateColumnName,
                      controller: textEditingController,
                      decoration: const InputDecoration(
                          //hintText: "Row " + (listIndex + 1).toString(),
                          hintText: "Row Name",
                          hintStyle: TextStyle(fontSize: 20),
                          labelText: 'Edit Column Name',
                          labelStyle: TextStyle(fontSize: 20),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  updateColumnName(int listIndex) async {
    connector = FireBaseConnector();
    Navigator.of(context).pop(textEditingController.text);
    //FB connector
    connector.UpdateColumnName(listIndex, textEditingController.text);
    textEditingController.clear();
  }

  updatePost(BoardPost updatedPost) {}

  createNewBoardPost(BoardPostColumn column) async {
    // if (kDebugMode) {
    //   print(column.title);
    // }
    int index = dbData.indexWhere((element) => element == column);
    BoardPost post = await connector.CreateNewBoardPost(index);
    setState(() {
      dbData
          .firstWhere((element) => element.items == column.items)
          .items!
          .add(post);
    });
  }

  Future<List<BoardPostColumn>> getDatabase() async {
    connector = FireBaseConnector();
    // connector.SaveAllColumns(testData);
    dbData = await connector.GetDataBase();
    return dbData;
    // if (dbData.isNotEmpty) {
    // }

    // print('I AM NOT HERE');
    // connector.SaveAllColumns(testData);
    // dbData = testData;
    // return dbData;
  }
}
