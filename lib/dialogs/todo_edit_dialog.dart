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
      margin: const EdgeInsets.all(50),
      child: Material(
        child: Container(
          
          decoration: const BoxDecoration(
            //color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (String value) => toDo.name = value,
                ),
              ),
              Image.file(toDo.imageId!,
                      width: 200, height: 200, fit: BoxFit.cover),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back'),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                                    onPressed: () {
                    onEditCompleted(toDo);
                    Navigator.of(context).pop();
                                    },
                                    child: const Text('Save'),
                                  ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
