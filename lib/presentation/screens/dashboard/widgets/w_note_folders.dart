import 'package:flutter/material.dart';

import '../../note_folders/w_note_folders.dart';

class NoteFoldersPage extends StatelessWidget {
  const NoteFoldersPage({super.key});

  static Widget actionButtonBuilder(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
    );
  }

  static List<Widget> actionsBuilder(BuildContext context) {
    return [const Icon(Icons.add)];
  }

  @override
  Widget build(BuildContext context) {
    return const NoteFoldersContent();
  }
}
