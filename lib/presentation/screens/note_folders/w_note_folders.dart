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
    // if (kReleaseMode) {
    //   return Center(
    //     child: Lottie.asset(
    //       Assets.lottie.onboarding.underDevelopment.path,
    //     ),
    //   );
    // }
    return BlocBuilder<NoteFolderCubit, NoteFolderState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final noteFolders =
            state.currentFolder?.subFolders ?? state.noteFolders;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent:
                PlatformChecker.defaultLogic().isMobile() ? 180 : 400,
          ),
          itemCount: noteFolders.length + 1,
          itemBuilder: (context, index) {
            if (index == noteFolders.length) {
              return GestureDetector(
                onTap: state.currentFolder != null
                    ? () => context.read<NoteFolderCubit>().navigateBack()
                    : null,
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
              );
            }
            final item = noteFolders[index];
            return NoteFolderTile(noteFolder: item);
          },
        );
      },
    );
  }
}
