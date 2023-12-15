import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../gen/assets.gen.dart';

class NoteFoldersContent extends StatefulWidget {
  const NoteFoldersContent({super.key});

  @override
  State<NoteFoldersContent> createState() => _NoteFoldersContentState();
}

class _NoteFoldersContentState extends State<NoteFoldersContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        Assets.lottie.onboarding.underDevelopment.path,
      ),
    );
  }
}
