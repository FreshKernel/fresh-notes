import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../gen/assets.gen.dart';
import '../../l10n/extensions/localizations.dart';

class ErrorWithTryAgain extends StatelessWidget {
  const ErrorWithTryAgain({
    required this.onTryAgain,
    required this.error,
    super.key,
  });
  final VoidCallback onTryAgain;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      Assets.lottie.error.error1.path,
    );
  }
}

class ErrorWithReport extends StatelessWidget {
  const ErrorWithReport({
    required this.onReport,
    required this.error,
    super.key,
  });
  final VoidCallback onReport;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            Assets.lottie.error.error1.path,
          ),
          const SizedBox(height: 8),
          Text('${context.loc.error}: ${error.toString()}'),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: onReport,
            child: Text(context.loc.report),
          ),
        ],
      ),
    );
  }
}

class ErrorWithoutTryAgain extends StatelessWidget {
  const ErrorWithoutTryAgain({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      Assets.lottie.error.error1.path,
    );
  }
}
