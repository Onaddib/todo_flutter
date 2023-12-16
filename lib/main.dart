import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/dialogs/todo_add_dialog.dart';
import 'package:todoapp/model/language_model.dart';
import 'package:todoapp/model/todo_model.dart';

import 'views/todo_item_widget.dart';

void main() {
  var path = Directory.current.path;
  Hive.init(path);

  runApp(const ToDoApp());
}

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ToDoAppState createState() => _ToDoAppState();

  // ignore: library_private_types_in_public_api
  static _ToDoAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_ToDoAppState>()!;
}

class _ToDoAppState extends State<ToDoApp> {
  _ToDoAppState();
  ThemeMode _themeMode = ThemeMode.system;

  final List<LanguageModel> _languages = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _languages.add(LanguageModel(code: 'en', name: 'english'));
    _languages.add(LanguageModel(code: 'es', name: 'espinosa'));
    _languages.add(LanguageModel(code: 'tr', name: 'turkish'));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: MaterialApp(
        title: 'Todo Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: _themeMode,
        home: const ToDoList(title: '?? Manager'),
      ),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key, required this.title});

  final String title;

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<TodoModel> _toDos = <TodoModel>[];

  void _handleToDoChange(TodoModel todo) {
    setState(() {
      todo.completed = !todo.completed;
    });
  }

  void _handleToDoDelete(TodoModel todo) {
    setState(() {
      _toDos.removeWhere((item) => item.id == todo.id);
    });
  }

  Future<void> _showAddDialog() async {
    return showDialog<TodoModel?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const TodoAddDialog(),
    ).then((value) async {
      if (value != null) {
        setState(() {
          _toDos.add(value);
        });

        var box = await Hive.openBox('TodosBox');

        String data = jsonEncode(value);
        box.put(value.id, data);
      }
    });
  }

  final items = ["item1", "item2"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: Center(
                    child: Text(
                  "Settings",

                  // style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize),
                ))),
            Card(
                color: Colors.amber[100],
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(padding: EdgeInsets.all(8)),
                      ElevatedButton(
                        onPressed: () =>
                            ToDoApp.of(context).changeTheme(ThemeMode.light),
                        child: const Text("Light"),
                      ),
                      const Padding(padding: EdgeInsets.all(8)),
                      ElevatedButton(
                          onPressed: () =>
                              ToDoApp.of(context).changeTheme(ThemeMode.dark),
                          child: const Text("Dark")),
                    ],
                  ),
                )),

            /*
            DropdownButton<LanguageModel>(  

              dropdownColor: Theme.of(context).primaryColor,
              iconEnabledColor: Theme.of(context).colorScheme.background,

              items: _languages.map<DropdownMenuItem<LanguageModel>>((LanguageModel value) {
                return DropdownMenuItem<LanguageModel>(
                  value: value,
                   child:const Text("heyy"),
                );
              }
              ), 
              
              onChanged: (LanguageModel? value) {  },
            ),

            */

/*
              ReorderableListView(

                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    final item = items.removeAt(oldIndex);
                    items.insert(newIndex, item);
                  });
                },
                children: [
                  for(final item in items)
                  ListTile(
                    key: ValueKey(item),
                    title: Text(item),
                  )
                ],
                
              )*/
          ],
        ),
      ),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.blue[900],
            height: 4.0,
          ),
        ),
        actions: [
          InkWell(
            // ignore: avoid_print
            onTap: () => print("Hive"),
            borderRadius: BorderRadius.circular(50),
            highlightColor: Colors.grey[600],
            hoverColor: Colors.grey[700],
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.settings),
            ),
          ),
        ],
        // backgroundColor: Colors.blue,
        title: const Text("To Do App"),
      ),
      body: Center(
        child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: _toDos.map((TodoModel todo) {
              return TodoItemWidget(
                todo: todo,
                onToDoChanged: _handleToDoChange,
                onToDoDeletet: _handleToDoDelete,
              );
            }).toList()),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 239, 147, 34),
        onPressed: () => _showAddDialog(),
        tooltip: 'Add a todo item',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        color: Colors.blue,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.red,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
