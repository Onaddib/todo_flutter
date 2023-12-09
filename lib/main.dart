import 'package:flutter/material.dart';

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
  ToDo({required this.name, required this.completed});
  String name;
  bool completed;
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

  void _addToDoItem(String name) {
    setState(() {
      _toDos.add(ToDo(name: name, completed: false));
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
      _toDos.removeWhere((item) => item.name == item.name);
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
                    _addToDoItem(_textFieldController.text);
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

class TodoItem extends StatelessWidget {
  TodoItem(
      {required this.todo,
      required this.onToDoChanged,
      required this.onToDoDeletet})
      : super(key: ObjectKey(todo));

  final ToDo todo;
  final void Function(ToDo todo) onToDoChanged;
  final void Function(ToDo todo) onToDoDeletet;
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
        onToDoChanged(todo);
      },
      leading: Checkbox(
        checkColor: Colors.greenAccent,
        activeColor: Colors.red,
        value: todo.completed,
        onChanged: (value) {
          onToDoChanged(todo);
        },
      ),
      title: Row(children: <Widget>[
        Expanded(
          child: Text(todo.name, style: _getTextStyle(todo.completed)),
        ),
        IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          alignment: Alignment.centerRight,
          onPressed: () {
            onToDoDeletet(todo);
          },
        ),
        IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.update,
            color: Colors.blue,
          ),
          alignment: Alignment.centerRight,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }
}
