import 'dart:io';

import 'package:equatable/equatable.dart';

// TODO: Convert this class to immutable
// ignore: must_be_immutable
class TodoModel extends Equatable {
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

  @override
  List<Object?> get props => [id, name, completed, imageFile];

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      name: json['name'],
      completed: json['completed'],
      imageFile: json['imageFile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'completed': completed,
      'imageFile': imageFile,
    };
  }
}
