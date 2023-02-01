import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../application/type_definition.dart';

part 'todo_model.g.dart';

enum RepeatStatus { none, daily, weakly, monthly }

@immutable
@JsonSerializable()
class TodoModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String date;
  final String startTime;
  final String endTime;
  final int color;
  final int remind;
  final RepeatStatus repeat;

  TodoModel({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.date = '',
    this.startTime = '',
    this.endTime = '',
    this.color = 0,
    this.remind = 5,
    this.repeat = RepeatStatus.none,
  })  
  /*The assert method takes a boolean expression as an argument, 
    and if the expression evaluates to false, it will trigger 
    an AssertionError and stop the execution of the app. */
  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        /**UUIDs are often used as primary keys in databases */
        id = id ?? const Uuid().v4();

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? date,
    String? startTime,
    String? endTime,
    int? color,
    int? remind,
    RepeatStatus? repeat,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      remind: remind ?? this.remind,
      repeat: repeat ?? this.repeat,
    );
  }

  factory TodoModel.fromJson(JsonMap json) => _$TodoModelFromJson(json);

  JsonMap toJson() => _$TodoModelToJson(this);

  @override
  List<Object> get props => [
        id,
        title,
        description,
        isCompleted,
        date,
        startTime,
        endTime,
        color,
        remind,
        repeat
      ];
}
