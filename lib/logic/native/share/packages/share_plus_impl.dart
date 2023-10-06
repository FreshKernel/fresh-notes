import 'dart:ui';

import 'package:share_plus/share_plus.dart';

import '../app_share.dart';

class AppShareSharePlusImpl extends AppShare {
  @override
  Future<void> shareText(String text,
      {String? subject, Rect? sharePositionOrigin}) async {
    await Share.share(
      text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
