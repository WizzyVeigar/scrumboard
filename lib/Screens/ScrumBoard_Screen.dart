import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:scrumboard/BoardListObject.dart';

class ScrumBoardScreen extends StatelessWidget {
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
      BoardPost(title: 'Data2', from: 'Person2')
    ])
  ].toList();

  BoardViewController boardViewController = new BoardViewController();

  @override
  Widget build(BuildContext context) {
    List<BoardList> _lists = [];
    for (int i = 0; i < data.length; i++) {
      _lists.add(_createBoardList(data[i]) as BoardList);
    }
    return BoardView(
      lists: _lists,
      boardViewController: boardViewController,
    );
  }

  Widget buildBoardItem(BoardPost itemObject) {
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
        onTapItem:
            (int? listIndex, int? itemIndex, BoardItemState? state) async {},
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemObject.title!),
          ),
        ));
  }

  Widget _createBoardList(BoardPostColumn list) {
    List<BoardItem> items = [];
    for (int i = 0; i < list.items!.length; i++) {
      items.insert(i, buildBoardItem(list.items![i]) as BoardItem);
    }

    return BoardList(
      onStartDragList: (int? listIndex) {},
      onTapList: (int? listIndex) async {},
      onDropList: (int? listIndex, int? oldListIndex) {
        //Update our local list data
        var list = data[oldListIndex!];
        data.removeAt(oldListIndex!);
        data.insert(listIndex!, list);
      },
      headerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
      backgroundColor: Color.fromARGB(255, 235, 236, 240),
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  list.title!,
                  style: TextStyle(fontSize: 20),
                ))),
      ],
      items: items,
    );
  }
}
