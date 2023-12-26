import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fresh_base_package/fresh_base_package.dart';

import '../../../core/log/logger.dart';
import '../../../logic/note/cubit/note_cubit.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../components/others/w_error.dart';
import '../../components/others/w_no_data.dart';
import '../../l10n/extensions/localizations.dart';
import '../../utils/extensions/build_context_ext.dart';
import 'note_tile/note_tile_options.dart';
import 'note_tile/w_note_grid_tile.dart';
import 'note_tile/w_note_tile.dart';

class NoteListContent extends StatefulWidget {
  const NoteListContent({
    required this.isTrashList,
    super.key,
  });

  final bool isTrashList;

  @override
  State<NoteListContent> createState() => _NoteListContentState();
}

class _NoteListContentState extends State<NoteListContent> {
  late final Future<void> _loadAllNotes;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAllNotes = context.read<NoteCubit>().loadAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await context.read<NoteCubit>().syncLocalNotesFromCloud();
      },
      child: FutureBuilder(
        future: _loadAllNotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                context.loc.unknownErrorWithMessage(
                  snapshot.error.toString(),
                ),
              ),
            );
          }

          return NotificationListener<ScrollEndNotification>(
            child: BlocConsumer<NoteCubit, NoteState>(
              listener: (context, state) {
                final exception = state.exception;
                if (exception != null) {
                  AppLogger.error(exception.toString());
                  context.messenger.showMessage(exception.toString());
                }
              },
              builder: (context, state) {
                if (state.exception != null) {
                  return ErrorWithReport(
                    onReport: () => context.read<NoteCubit>().reportError(),
                    error: state.exception.toString(),
                  );
                }

                final notes = state.notes
                    .where((note) =>
                        widget.isTrashList ? note.isTrash : !note.isTrash)
                    .toList();

                if (notes.isEmpty) {
                  return const NoDataWithoutTryAgain();
                }

                final settingsBloc = context.watch<SettingsCubit>();
                if (!settingsBloc.state.useNoteGridTile) {
                  return MasonryGridView.builder(
                    controller: _scrollController,
                    itemCount: notes.length,
                    gridDelegate:
                        SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          PlatformChecker.defaultLogic().isDesktop()
                              ? 400
                              : 200,
                    ),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return NoteGridTile(
                        key: ValueKey(note.noteId),
                        options: NoteTileOptions(
                          note: note,
                          index: index,
                        ),
                      );
                    },
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteTile(
                      key: ValueKey(note.noteId),
                      options: NoteTileOptions(
                        note: note,
                        index: index,
                      ),
                    );
                  },
                );
              },
            ),
            onNotification: (scrollEnd) {
              if (!scrollEnd.metrics.atEdge) {
                return true;
              }
              final isTop = scrollEnd.metrics.pixels == 0;
              if (isTop) {
                return true;
              }
              context.read<NoteCubit>().loadMoreNotes();
              return true;
            },
          );
        },
      ),
    );
  }
}
