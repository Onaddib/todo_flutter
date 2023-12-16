import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoAddDialog extends StatefulWidget {
  const TodoAddDialog({super.key});

  @override
  State<TodoAddDialog> createState() => _TodoAddDialogState();
}

class _TodoAddDialogState extends State<TodoAddDialog> {
  final TextEditingController _textFieldController = TextEditingController();

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Not Ekle!"),
      content: Column(
        children: <Widget>[
          TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Buraya Giriniz'),
            autofocus: true,
          ),
          if (imageFile != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 250,
                  maxWidth: 250,
                ),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
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
            if (validateInput(context)) {
              var uuid = const Uuid();

              Navigator.of(context).pop<TodoModel>(
                TodoModel(
                  id: uuid.v4(),
                  name: _textFieldController.text,
                  completed: false,
                  imageFile: imageFile,
                ),
              );
            }
          },
          child: const Text('Ekle'),
        ),
        ElevatedButton(onPressed: getImage, child: const Text("resim"))
      ],
    );
  }

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    return setState(() {
      imageFile = File(image.path);
    });
  }

  bool validateInput(BuildContext context) {
    if (_textFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir not giriniz'),
        ),
      );

      return false;
    }

    return true;
  }
}
