import 'dart:ui';

import '../../../core/app_module.dart';
import 'app_share.dart';
import 'packages/share_plus_impl.dart';

class AppShareService extends AppShare {
  AppShareService(this._provider);

  factory AppShareService.sharePlus() =>
      AppShareService(AppShareSharePlusImpl());

  factory AppShareService.getInstance() => AppModule.appShareService;

  final AppShare _provider;
  @override
  Future<void> shareText(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) =>
      _provider.shareText(
        text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );
}
