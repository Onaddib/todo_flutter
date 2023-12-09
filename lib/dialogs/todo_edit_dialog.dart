import 'package:flutter/material.dart';

import '../main.dart';

class TodoEditDialog extends StatelessWidget {
  final ToDo toDo;
  final Function(ToDo) onEditCompleted;

  const TodoEditDialog({
    super.key,
    required this.toDo,
    required this.onEditCompleted,
  });

  TextEditingController get _textEditingController =>
      TextEditingController(text: toDo.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textEditingController,
                onChanged: (String value) => toDo.name = value,
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  onEditCompleted(toDo);
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
