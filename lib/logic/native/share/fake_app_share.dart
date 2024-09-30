import 'dart:ui';

import 'app_share.dart';

class FakeAppShare extends AppShare {
  @override
  Future<void> shareText(String text,
      {required String? subject, Rect? sharePositionOrigin}) async {
    // TODO: share_plus was removed due to build failure and some other issues
    // such as always requiring the latest Kotlin version as the minimum which
    // causing issues in production mode
  }
}
