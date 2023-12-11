import 'package:flutter/material.dart';

import '../../note_list/w_notes_list.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const NoteListContent(
      isTrashList: false,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
