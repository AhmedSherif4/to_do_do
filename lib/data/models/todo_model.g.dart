// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => TodoModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      color: json['color'] as int? ?? 0,
      remind: json['remind'] as int? ?? 5,
      repeat: $enumDecodeNullable(_$RepeatStatusEnumMap, json['repeat']) ??
          RepeatStatus.none,
    );

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'date': instance.date,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'color': instance.color,
      'remind': instance.remind,
      'repeat': _$RepeatStatusEnumMap[instance.repeat]!,
    };

const _$RepeatStatusEnumMap = {
  RepeatStatus.none: 'none',
  RepeatStatus.daily: 'daily',
  RepeatStatus.weakly: 'weakly',
  RepeatStatus.monthly: 'monthly',
};
