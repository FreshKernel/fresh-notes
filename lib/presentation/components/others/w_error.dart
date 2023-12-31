import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../gen/assets.gen.dart';
import '../../l10n/extensions/localizations.dart';

// Not completed
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
    return Center(
      child: Lottie.asset(
        Assets.lottie.error.error1.path,
      ),
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
          Text(
            context.loc.unknownErrorWithMessage(
              error.toString(),
            ),
            style: Theme.of(context).textTheme.titleMedium,
          ),
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
  const ErrorWithoutTryAgain({
    required this.error,
    super.key,
  });

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
          Text(
            context.loc.unknownErrorWithMessage(
              error.toString(),
            ),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
