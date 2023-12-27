import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../notes/universal/models/m_note.dart';

part 'm_note_folder.freezed.dart';

@freezed
class NoteFolder with _$NoteFolder {
  const factory NoteFolder({
    required String folderName,
    required List<Directory> folders,
    required List<UniversalNote> notes,
  }) = _NoteFolder;
}
