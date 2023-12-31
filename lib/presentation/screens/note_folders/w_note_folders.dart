import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_base_package/fresh_base_package.dart';

import '../../../logic/note_folder/cubit/note_folder_cubit.dart';
import '../../l10n/extensions/localizations.dart';
import 'w_note_folder_tile.dart';

class NoteFoldersContent extends StatefulWidget {
  const NoteFoldersContent({super.key});

  @override
  State<NoteFoldersContent> createState() => _NoteFoldersContentState();
}

class _NoteFoldersContentState extends State<NoteFoldersContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFolderCubit, NoteFolderState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final noteFolders =
            state.currentFolder?.subFolders ?? state.noteFolders;

        return GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent:
                PlatformChecker.defaultLogic().isMobile() ? 180 : 400,
          ),
          children: [
            if (state.currentFolder != null)
              GestureDetector(
                onTap: context.read<NoteFolderCubit>().navigateBack,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.folder,
                        size: 50,
                      ),
                      const SizedBox(height: 20),
                      Text(context.loc.back),
                    ],
                  ),
                ),
              ),
            ...noteFolders.map((item) => NoteFolderTile(noteFolder: item))
          ],
        );
      },
    );
  }
}
