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
}
