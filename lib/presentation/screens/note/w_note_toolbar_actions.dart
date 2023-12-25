import 'dart:convert' show jsonEncode;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_quill_extensions/utils/quill_image_utils.dart';
import 'package:gal/gal.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/log/logger.dart';
import '../../../core/start/packages/flutter_local_notifications.dart';
import '../../../data/constants/urls_constants.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../logic/auth/auth_service.dart';
import '../../../logic/native/share/s_app_share.dart';
import '../../../logic/quill/delta_pdf.dart';
import '../../l10n/extensions/localizations.dart';
import '../../utils/extensions/build_context_ext.dart';
import 'w_share_dialog.dart';

final _menuController = MenuController();

List<Widget> noteScreenActions({
  required BuildContext context,
  required QuillController controller,
  required bool isSyncWithCloud,
  required Function(bool newValue) onUpdateIsSyncWithCloud,
  required bool isPrivate,
  required Function(bool newValue) onUpdateIsPrivate,
  required UniversalNote? note,
  required ScreenshotController screenshotController,
}) =>
    [
      QuillToolbarSearchButton(
        controller: controller,
        options: const QuillToolbarSearchButtonOptions(),
      ),
      IconButton(
        onPressed: () async {
          tz.initializeTimeZones();
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time == null) {
            return;
          }
          await FlutterLocalNotificationsService.localNotificationsPlugin
              .zonedSchedule(
            0,
            'scheduled title',
            'scheduled body',
            tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
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
          SubmenuButton(
            menuChildren: [
              MenuItemButton(
                onPressed: () async {
                  final doc = pw.Document();
                  final pdfWidget = await DeltaToPDF().deltaToPDF(
                    controller.document.toDelta(),
                  );
                  doc.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (context) {
                        return pdfWidget;
                      },
                    ),
                  );
                  await Printing.layoutPdf(
                    onLayout: (format) async => doc.save(),
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
                if (!isSyncWithCloud) {
                  onUpdateIsPrivate(true);
                }
                onUpdateIsSyncWithCloud(!isSyncWithCloud);
              },
              icon: Icon(
                isSyncWithCloud ? Icons.cloud : Icons.folder,
                semanticLabel: isSyncWithCloud
                    ? context.loc.syncWithCloud
                    : context.loc.saveLocally,
              ),
              label: Text(
                isSyncWithCloud
                    ? context.loc.syncWithCloud
                    : context.loc.saveLocally,
              ),
            ),
            if (isSyncWithCloud)
              TextButton.icon(
                onPressed: isSyncWithCloud
                    ? () => onUpdateIsPrivate(!isPrivate)
                    : null,
                icon: Icon(
                  isPrivate ? Icons.lock : Icons.public,
                  semanticLabel:
                      isPrivate ? context.loc.private : context.loc.public,
                ),
                label: Text(
                  isPrivate ? context.loc.private : context.loc.public,
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
                  if (isPrivate || note == null) {
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
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.star_border),
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
