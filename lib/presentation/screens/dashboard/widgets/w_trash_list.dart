import 'package:flutter/material.dart';

import '../../note_list/w_note_list.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const NoteListContent(isTrashList: true);
  }

  @override
  bool get wantKeepAlive => true;
}
