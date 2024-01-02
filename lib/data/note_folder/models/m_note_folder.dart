// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

import '../../notes/universal/models/m_note.dart';

@immutable
class NoteFolder extends Equatable {
  const NoteFolder({
    required this.folderPath,
    required this.subFolders,
    required this.notes,
  });

  final String folderPath;
  final List<NoteFolder> subFolders;
  final List<UniversalNote> notes;

  String get folderName => path.basename(folderPath);

  @override
  List<Object?> get props => [folderName, subFolders, notes];

  NoteFolder copyWith({
    String? folderPath,
    List<NoteFolder>? subFolders,
    List<UniversalNote>? notes,
  }) {
    return NoteFolder(
      folderPath: folderPath ?? this.folderPath,
      subFolders: subFolders ?? this.subFolders,
      notes: notes ?? this.notes,
    );
  }
}
