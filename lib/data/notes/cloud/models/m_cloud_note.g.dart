// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_cloud_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CloudNoteImpl _$$CloudNoteImplFromJson(Map<String, dynamic> json) =>
    _$CloudNoteImpl(
      id: json['id'] as String,
      noteId: json['noteId'] as String,
      userId: json['userId'] as String?,
      title: json['title'] as String,
      text: json['text'] as String,
      isPrivate: json['isPrivate'] as bool,
      isTrash: json['isTrash'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CloudNoteImplToJson(_$CloudNoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'userId': instance.userId,
      'title': instance.title,
      'text': instance.text,
      'isPrivate': instance.isPrivate,
      'isTrash': instance.isTrash,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
