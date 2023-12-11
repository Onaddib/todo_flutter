import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/dialogs/todo_edit_dialog.dart';

void main() {
  //main
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: MaterialApp(
        title: 'Todo Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const ToDoList(title: '?? Manager'),
      ),
    );
  }
}

class ToDo {
  ToDo({required this.name, required this.completed, required this.id});
  String name;
  bool completed;
  int id;
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key, required this.title});

  final String title;

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<ToDo> _toDos = <ToDo>[];
  final TextEditingController _textFieldController = TextEditingController();
  int _counter = 1;

  void incrementer() {
    setState(() {
      _counter++;
    });
  }

  void _addToDoItem(String name, int id) {
    setState(() {
      _toDos.add(ToDo(name: name, id: _counter, completed: false));
    });
    _textFieldController.clear();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.completed = !todo.completed;
    });
  }

  void _handleToDoDelete(ToDo todo) {
    setState(() {
      _toDos.removeWhere((item) => item.id == item.id);
    });
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Not Ekle!'),
              content: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(hintText: 'Buraya Giriniz'),
                autofocus: true,
              ),
              actions: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('iptal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addToDoItem(_textFieldController.text, _counter);
                    incrementer();
                  },
                  child: const Text('ekle'),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("To Do App"),
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: _toDos.map((ToDo todo) {
              return TodoItem(
                todo: todo,
                onToDoChanged: _handleToDoChange,
                onToDoDeletet: _handleToDoDelete,
              );
            }).toList()),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                backgroundColor: Colors.indigoAccent,
                onPressed: () => _displayDialog(),
                tooltip: 'Add a todo',
                child: const Icon(Icons.add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 239, 147, 34),
                onPressed: () => _displayDialog(),
                tooltip: 'Add a pic',
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ));
  }
}

class TodoItem extends StatefulWidget {
  TodoItem(
      {required this.todo,
      required this.onToDoChanged,
      required this.onToDoDeletet})
      : super(key: ObjectKey(todo));

  final ToDo todo;
  final void Function(ToDo todo) onToDoChanged;
  final void Function(ToDo todo) onToDoDeletet;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }

  void onTodoUpdatedCallBack(ToDo updatedTodo) {
    if (kDebugMode) {
      print("${updatedTodo.name} ve ${updatedTodo.id} guncellendi");

      setState(() {
        widget.todo.id = updatedTodo.id;
        widget.todo.completed = updatedTodo.completed;
      });
    }
  }
}
