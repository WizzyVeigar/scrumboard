import 'dart:developer';

import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:scrumboard/BoardListObject.dart';

class ScrumBoardScreen extends StatefulWidget {
  @override
  State<ScrumBoardScreen> createState() => _ScrumBoardScreenState();
}

class _ScrumBoardScreenState extends State<ScrumBoardScreen> {
  List<BoardPostColumn> data = [
    //In here you map the data to your Scrum board
    BoardPostColumn(title: 'Row 1', items: [
      BoardPost(title: 'Data', from: 'Person1'),
      BoardPost(title: 'Data2', from: 'Person2')
    ]),
    BoardPostColumn(title: 'Row 2', items: [
      BoardPost(title: 'Data', from: 'Person1'),
      BoardPost(title: 'Data2', from: 'Person2')
    ]),
    BoardPostColumn(title: 'Row 3', items: [
      BoardPost(title: 'Data', from: 'Person1'),
      BoardPost(title: 'Data2', from: 'Person2')
    ]),
    BoardPostColumn(title: 'Row 4', items: [
      BoardPost(title: 'Data', from: 'Person1'),
      BoardPost(title: 'Data', from: 'Person2'),
      BoardPost(title: 'Data', from: 'Person3'),
      BoardPost(title: 'Data', from: 'Person4'),
      BoardPost(title: 'Data2', from: 'Person5')
    ])
  ].toList();

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
    List<BoardList> _lists = [];
    for (int i = 0; i < data.length; i++) {
      _lists.add(CreateBoardList(data[i], context));
    }
    return BoardView(
      lists: _lists,
      boardViewController: boardViewController,
    );
  }

  ///Creates a [BoardList] with drag n drop functionality
  BoardList CreateBoardList(BoardPostColumn list, BuildContext context) {
    List<BoardItem> items = [];
    for (int i = 0; i < list.items!.length; i++) {
      items.insert(i, buildBoardItem(list.items![i], context));
    }

    return BoardList(
      onStartDragList: (int? listIndex) {},
      //OnTap for each individual task, open an edit dialog box
      onTapList: (int? listIndex) async {
        final inputText = await OpenEditColumnNameDialog(listIndex!);
        if (inputText == null || inputText.isEmpty) return;
        setState(() => data[listIndex].title = inputText);
      },
      onDropList: (int? listIndex, int? oldListIndex) {
        //Update our local list data
        var list = data[oldListIndex!];
        data.removeAt(oldListIndex!);
        data.insert(listIndex!, list);
      },
      headerBackgroundColor: Color(0xFFEBECF0),
      backgroundColor: Color(0xFFEBECF0),
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  list.title,
                  style: TextStyle(fontSize: 20),
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
          var item = data[oldListIndex!].items![oldItemIndex!];
          data[oldListIndex].items!.removeAt(oldItemIndex!);
          data[listIndex!].items!.insert(itemIndex!, item);
        },
        //Holder for tasks, use ontap to rename the thingy
        onTapItem:
            (int? listIndex, int? itemIndex, BoardItemState? state) async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(data[listIndex!].items[itemIndex!].title),
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

  Future<String?> OpenEditColumnNameDialog(int listIndex) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(data[listIndex!].title),
          actions: [
            TextButton(
              onPressed: UpdateColumnName,
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
                      onSubmitted: (value) => UpdateColumnName(),
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: "Row " + (listIndex + 1).toString(),
                          hintStyle: const TextStyle(fontSize: 20),
                          labelText: 'Edit Column Name',
                          labelStyle: TextStyle(fontSize: 20),
                          border: const UnderlineInputBorder(),
                          focusedBorder: const UnderlineInputBorder()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  UpdateColumnName() async {
    Navigator.of(context).pop(textEditingController.text);
    textEditingController.clear();
  }
}
