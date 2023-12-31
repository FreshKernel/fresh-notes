import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';

import '../../../data/notes/universal/models/m_note.dart';
import '../../../logic/note/cubit/note_cubit.dart';
import '../../components/others/w_error.dart';
import '../note/s_note.dart';

class NoteSearchDelegate extends SearchDelegate<UniversalNote> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => context.pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final future = context.read<NoteCubit>().searchAllNotes(searchQuery: query);
    return FutureBuilder<Iterable<UniversalNote>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasError) {
          return ErrorWithoutTryAgain(
            error: snapshot.error.toString(),
          );
        }
        final list = snapshot.requireData.toList();
        return ListView.builder(
          itemBuilder: (context, index) {
            final item = list[index];
            return ListTile(
              onTap: () => context.push(
                NoteScreen.routeName,
                extra: NoteScreenArgs(note: item),
              ),
              title: Text(item.title),
              subtitle: Text(
                Document.fromJson(jsonDecode(item.text)).toPlainText(),
              ),
            );
          },
          itemCount: list.length,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}
