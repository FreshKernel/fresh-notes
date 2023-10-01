// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_local_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LocalNote _$$_LocalNoteFromJson(Map<String, dynamic> json) => _$_LocalNote(
      id: json['id'] as String,
      userId: json['userId'] as String,
      text: json['text'] as String,
      cloudId: json['cloudId'] as String?,
      isSyncWithCloud: json['isSyncWithCloud'] as bool,
      isPrivate: json['isPrivate'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$_LocalNoteToJson(_$_LocalNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'text': instance.text,
      'cloudId': instance.cloudId,
      'isSyncWithCloud': instance.isSyncWithCloud,
      'isPrivate': instance.isPrivate,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
