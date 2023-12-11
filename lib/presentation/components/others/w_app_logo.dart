import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';

class AppCircleLogo extends StatelessWidget {
  const AppCircleLogo({this.maxRadius, super.key, this.minRadius = 30});

  final double minRadius;
  final double? maxRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage(Assets.images.appLogo.path),
      minRadius: minRadius,
      maxRadius: maxRadius,
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.images.appLogo.path,
      width: size,
      height: size,
    );
  }
}
