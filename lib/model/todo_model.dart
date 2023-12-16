import 'dart:io';

class TodoModel {
  String name;
  File? imageFile;
  bool completed;

  final String id;

  TodoModel({
    required this.id,
    required this.name,
    required this.completed,
    required this.imageFile,
  });
}
