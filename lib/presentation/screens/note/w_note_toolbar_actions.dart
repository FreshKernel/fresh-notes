import 'dart:convert' show jsonEncode;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'package:gal/gal.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/log/logger.dart';
import '../../../data/constants/urls_constants.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../logic/auth/auth_service.dart';
import '../../../logic/native/share/s_app_share.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../../logic/utils/quill_image_utils.dart';
import '../../l10n/extensions/localizations.dart';
import '../../utils/extensions/build_context_ext.dart';
import '../note_list/note_tile/note_tile_options.dart';
import 'w_share_dialog.dart';

@immutable
class NoteScreenToolbarState extends Equatable {
  const NoteScreenToolbarState({
    required this.isFavorite,
    required this.isSyncWithCloud,
    required this.isPrivate,
  });

  final bool isFavorite;
  final bool isSyncWithCloud;
  final bool isPrivate;

  NoteScreenToolbarState copyWith({
    bool? isFavorite,
    bool? isSyncWithCloud,
    bool? isPrivate,
  }) {
    return NoteScreenToolbarState(
      isFavorite: isFavorite ?? this.isFavorite,
      isSyncWithCloud: isSyncWithCloud ?? this.isSyncWithCloud,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  @override
  List<Object?> get props => [
        isFavorite,
        isSyncWithCloud,
        isPrivate,
      ];
}

final _menuController = MenuController();

List<Widget> noteScreenActions({
  required BuildContext context,
  required QuillController controller,
  required UniversalNote? note,
  required ScreenshotController screenshotController,
  required NoteScreenToolbarState toolbarState,
  required Function(NoteScreenToolbarState noteScreenToolbarState)
      onUpdateToolbarState,
  required VoidCallback onRequestSaveNote,
}) =>
    [
      QuillToolbarSearchButton(
        controller: controller,
        options: const QuillToolbarSearchButtonOptions(),
      ),
      MenuAnchor(
        controller: _menuController,
        menuChildren: [
          if (kDebugMode)
            MenuItemButton(
              onPressed: () {
                AppLogger.log(
                  jsonEncode(
                    controller.document.toDelta().toJson(),
                  ),
                );
                AppLogger.log(
                  // ignore: deprecated_member_use_from_same_package
                  QuillImageUtilities(document: controller.document)
                      .getImagesPathsFromDocument(onlyLocalImages: false),
                );
              },
              child: Text(context.loc.print),
            ),
          if (!context.read<SettingsCubit>().state.autoSaveNote)
            MenuItemButton(
              child: Text(context.loc.save),
              onPressed: () {
                onRequestSaveNote();
              },
            ),
          SubmenuButton(
            menuChildren: [
              MenuItemButton(
                onPressed: () async {
                  final PDFConverter pdfConverter = PDFConverter(
                    fallbacks: [pw.Font.courier()],
                    textDirection: Directionality.of(
                      context,
                    ),
                    document: controller.document.toDelta(),
                    pageFormat: PDFPageFormat.all(width: 250, height: 250),
                  );

                  final pdfDocument = await pdfConverter.createDocument();
                  if (pdfDocument == null) {
                    throw StateError(
                      'Pdf document is expected to be not null.',
                    );
                  }
                  await Printing.layoutPdf(
                    onLayout: (format) async => pdfDocument.save(),
                  );
                },
                child: const Text('PDF'),
              ),
              MenuItemButton(
                child: Text(context.loc.image),
                onPressed: () async {
                  final imageBytes = await screenshotController.capture();
                  if (imageBytes == null) {
                    return;
                  }
                  await Gal.putImageBytes(imageBytes);
                },
              ),
            ],
            child: Text(context.loc.saveFileAs),
          ),
          if (AuthService.getInstance().isAuthenticated) ...[
            TextButton.icon(
              onPressed: () {
                if (!toolbarState.isSyncWithCloud) {
                  onUpdateToolbarState(toolbarState.copyWith(isPrivate: true));
                }
                onUpdateToolbarState(toolbarState.copyWith(
                  isSyncWithCloud: !toolbarState.isSyncWithCloud,
                ));
              },
              icon: Icon(
                toolbarState.isSyncWithCloud ? Icons.cloud : Icons.folder,
                semanticLabel: toolbarState.isSyncWithCloud
                    ? context.loc.syncWithCloud
                    : context.loc.saveLocally,
              ),
              label: Text(
                toolbarState.isSyncWithCloud
                    ? context.loc.syncWithCloud
                    : context.loc.saveLocally,
              ),
            ),
            if (toolbarState.isSyncWithCloud)
              TextButton.icon(
                onPressed: toolbarState.isSyncWithCloud
                    ? () => onUpdateToolbarState(
                          toolbarState.copyWith(
                              isPrivate: !toolbarState.isPrivate),
                        )
                    : null,
                icon: Icon(
                  toolbarState.isPrivate ? Icons.lock : Icons.public,
                  semanticLabel: toolbarState.isPrivate
                      ? context.loc.private
                      : context.loc.public,
                ),
                label: Text(
                  toolbarState.isPrivate
                      ? context.loc.private
                      : context.loc.public,
                ),
              ),
          ],
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  _menuController.close();
                  final messenger = context.messenger;
                  final plainText = controller.document.toPlainText(
                    FlutterQuillEmbeds.defaultEditorBuilders(),
                  );
                  if (plainText.trim().isEmpty) {
                    messenger.showMessage(
                      context.loc.pleaseEnterATextBeforeSharingTheNote,
                    );
                    return;
                  }
                  if (toolbarState.isPrivate || note == null) {
                    await AppShareService.getInstance().shareText(plainText);
                    return;
                  }
                  final shareOption = await showModalBottomSheet<ShareOption>(
                    showDragHandle: true,
                    context: context,
                    constraints: const BoxConstraints(maxWidth: 640),
                    builder: (context) => const NoteShareDialog(),
                  );
                  if (shareOption == null) {
                    return;
                  }
                  switch (shareOption) {
                    case ShareOption.link:
                      await AppShareService.getInstance().shareText(
                        '${UrlConstants.webUrl}/note/${note.noteId}',
                      );
                      break;
                    case ShareOption.text:
                      await AppShareService.getInstance().shareText(plainText);
                      break;
                  }
                },
                icon: const Icon(Icons.share),
              ),
              if (note != null)
                IconButton(
                  onPressed: () async {
                    _menuController.close();
                    final navigator = context.navigator;
                    final deleted =
                        await NoteTileOptions.sharedOnMoveToDeletePressed(
                            context: context, note: note);
                    if (deleted) {
                      navigator.pop();
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              IconButton(
                onPressed: () {
                  onUpdateToolbarState(toolbarState.copyWith(
                      isFavorite: !toolbarState.isFavorite));
                  _menuController.close();
                },
                icon: Icon(
                  toolbarState.isFavorite ? Icons.star : Icons.star_outline,
                ),
              ),
            ],
          ),
        ],
        child: IconButton(
          onPressed: () {
            if (_menuController.isOpen) {
              _menuController.close();
              return;
            }
            _menuController.open();
          },
          icon: const Icon(Icons.more_vert),
        ),
      ),
    ];
