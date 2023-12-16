import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../dialogs/todo_edit_dialog.dart';
import '../model/todo_model.dart';

class TodoItemWidget extends StatefulWidget {
  TodoItemWidget(
      {required this.todo,
      required this.onToDoChanged,
      required this.onToDoDeletet})
      : super(key: ObjectKey(todo));

  final TodoModel todo;
  final void Function(TodoModel todo) onToDoChanged;
  final void Function(TodoModel todo) onToDoDeletet;

  @override
  State<TodoItemWidget> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItemWidget> {
  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement expansion tile, show image in expansion tile
    // Show an icon, if there is an image for this todo

    return Card(
      margin: const EdgeInsets.all(5),
      elevation: 5,
      //color: Colors.lightBlue[50],
      child: ListTile(
        onTap: () {
          widget.onToDoChanged(widget.todo);
        },
        leading: Checkbox(
          checkColor: Colors.greenAccent,
          activeColor: Colors.red,
          value: widget.todo.completed,
          onChanged: (value) {
            widget.onToDoChanged(widget.todo);
          },
        ),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(widget.todo.name,
                  style: _getTextStyle(widget.todo.completed)),
            ),
            widget.todo.imageFile != null
                ? Image.file(
                    widget.todo.imageFile!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Container(),
            IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              alignment: Alignment.centerRight,
              onPressed: () {
                widget.onToDoDeletet(widget.todo);
              },
            ),
            IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              alignment: Alignment.centerRight,
              onPressed: () {
                showDialog(
                  useSafeArea: true,
                  context: context,
                  builder: (context) => TodoEditDialog(
                    toDo: widget.todo,
                    onEditCompleted: onTodoUpdatedCallBack,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void onTodoUpdatedCallBack(TodoModel updatedTodo) {
    if (kDebugMode) {
      print("${updatedTodo.name} ve ${updatedTodo.id} guncellendi");

      setState(() {
        widget.todo.completed = updatedTodo.completed;
      });
    }
  }
}
