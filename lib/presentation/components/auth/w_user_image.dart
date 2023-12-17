import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../logic/auth/auth_user.dart';
import '../../l10n/extensions/localizations.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    required this.user,
    required this.iconSize,
    super.key,
    this.containerSize,
  });

  final AuthUser user;
  final double? containerSize;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: CircleAvatar(
        backgroundImage: (user.data.photoUrl != null)
            ? CachedNetworkImageProvider(
                user.data.photoUrl.toString(),
              )
            : null,
        child: (user.data.photoUrl == null)
            ? Icon(
                Icons.person,
                size: iconSize,
                semanticLabel: context.loc.profilePicture,
              )
            : null,
      ),
    );
  }
}
