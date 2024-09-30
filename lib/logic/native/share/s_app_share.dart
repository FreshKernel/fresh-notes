import 'dart:ui';

import '../../../core/app_module.dart';
import 'app_share.dart';
import 'fake_app_share.dart';

class AppShareService extends AppShare {
  AppShareService(this._provider);

  factory AppShareService.sharePlus() => AppShareService(FakeAppShare());

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
