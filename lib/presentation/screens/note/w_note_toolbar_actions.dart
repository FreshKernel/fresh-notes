import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_quill_extensions/utils/quill_image_utils.dart';
import 'package:gal/gal.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quill_pdf_converter/quill_pdf_converter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/log/logger.dart';
import '../../../core/start/packages/flutter_local_notifications.dart';
import '../../../data/constants/urls_constants.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../logic/auth/auth_service.dart';
import '../../../logic/native/share/s_app_share.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
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
      if (note != null)
        IconButton(
          onPressed: () async {
            tz.initializeTimeZones();
            final dateTime = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 5000)),
              initialDate: DateTime.now(),
            );
            if (dateTime == null) {
              return;
            }
            if (!context.mounted) {
              return;
            }
            final timeOfDay = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (timeOfDay == null) {
              return;
            }
            final newDate = dateTime.copyWith(
                hour: timeOfDay.hour, minute: timeOfDay.minute);
            final currentDate = DateTime.now();

            final duration = newDate.difference(currentDate);
            await FlutterLocalNotificationsService.getInstance()
                .requestPermission();
            await FlutterLocalNotificationsService.getInstance()
                .localNotificationsPlugin
                .zonedSchedule(
                  0,
                  note.title,
                  Document.fromJson(jsonDecode(note.text)).toPlainText(),
                  tz.TZDateTime.now(tz.local).add(duration),
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      'note_alarms',
                      'Note alarms',
                      channelDescription: 'Your note alarms',
                    ),
                  ),
                  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                  uiLocalNotificationDateInterpretation:
                      UILocalNotificationDateInterpretation.absoluteTime,
                );
          },
          icon: const Icon(Icons.notification_add),
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
                  final pdfDocument = pw.Document();
                  final pdfWidgets =
                      await controller.document.toDelta().toPdf();
                  pdfDocument.addPage(
                    pw.MultiPage(
                      maxPages: 200,
                      pageFormat: PdfPageFormat.a4,
                      build: (context) {
                        return pdfWidgets;
                      },
                    ),
                  );
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
                    QuillEditorUnknownEmbedBuilder(),
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
