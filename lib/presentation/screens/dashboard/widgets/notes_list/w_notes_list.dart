import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/notes/universal/models/m_note.dart';
import '../../../../../data/notes/universal/s_universal_notes.dart';
import '../../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../../utils/form_factor.dart';
import 'note_item/note_item_options.dart';
import 'note_item/w_note_grid_item.dart';
import 'note_item/w_note_item.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage>
    with AutomaticKeepAliveClientMixin {
  late final UniversalNotesService _notesDataService;
  late final Stream<List<UniversalNote>> _noteStream;

  @override
  void initState() {
    super.initState();
    _notesDataService = UniversalNotesService.getInstance();
    _notesDataService.startAndFetchAllNotes();
    _noteStream = _notesDataService.notesStreamController.stream;
  }

  @override
  void dispose() {
    _notesDataService.deInitialize();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _noteStream,
      initialData: const <UniversalNote>[],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final notes = snapshot.requireData;

        if (notes.isEmpty || !snapshot.hasData) {
          return const Center(
            child: Text("You don't have any notes yet, start adding some!"),
          );
        }

        return Builder(
          builder: (context) {
            final settingsBloc = context.watch<SettingsCubit>();
            if (settingsBloc.state.useNoteGridItem) {
              return GridView.builder(
                itemCount: notes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.withFormFactor(
                    mobile: 1,
                    tablet: 2,
                    desktop: 4,
                  ),
                ),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteGridItem(
                    key: ValueKey(note.id),
                    options: NoteItemOptions(
                      notesDataService: _notesDataService,
                      note: note,
                      index: index,
                    ),
                  );
                },
              );
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteItem(
                  key: ValueKey(note.id),
                  options: NoteItemOptions(
                    notesDataService: _notesDataService,
                    note: note,
                    index: index,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
