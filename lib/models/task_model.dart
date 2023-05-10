import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class TaskModel {
  final String title;
  final String description;
  final DateTime createdAt;
  final String uid;
  final String priority;
  final bool isCompleted;
  final String id;
  const TaskModel({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.uid,
    required this.priority,
    required this.isCompleted,
    required this.id
  });
  

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    String? uid,
    String? priority,
    bool? isCompleted,
    String? id,
  }) {
    return TaskModel(
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      uid: uid ?? this.uid,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'uid': uid});
    result.addAll({'priority': priority});
    result.addAll({'isCompleted': isCompleted});
    return result;
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      uid: map['uid'] ?? '',
      priority: map['priority'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
       id: map['\$id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskModel(title: $title, description: $description, createdAt: $createdAt, uid: $uid, priority: $priority,isCompleted: $isCompleted ,id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TaskModel &&
      other.title == title &&
      other.description == description &&
      other.createdAt == createdAt &&
      other.uid == uid &&
      other.priority == priority &&
      other.isCompleted == isCompleted &&
      other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      uid.hashCode ^
      priority.hashCode ^
      isCompleted.hashCode ^
      id.hashCode;
  }
}
