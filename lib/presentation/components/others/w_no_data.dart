import 'dart:math' as math;

import 'package:flutter/material.dart' show ElevatedButton, Theme;
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../../../gen/assets.gen.dart';
import '../../l10n/extensions/localizations.dart';

class _LottieNoDataWidget extends StatelessWidget {
  const _LottieNoDataWidget();

  @override
  Widget build(BuildContext context) {
    final asset = Assets.lottie.noData
        .values[math.Random().nextInt(Assets.lottie.noData.values.length)].path;
    return LayoutBuilder(
      builder: (context, constranints) {
        final isLandscape =
            MediaQuery.orientationOf(context) == Orientation.landscape;
        if (isLandscape) {
          return Lottie.asset(
            asset,
            width: constranints.maxWidth * 0.6,
          );
        }
        return Lottie.asset(asset);
      },
    );
  }
}

class NoDataWithTryAgain extends StatelessWidget {
  const NoDataWithTryAgain({
    required this.onRefresh,
    super.key,
  });
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _LottieNoDataWidget(),
          ElevatedButton(
            onPressed: onRefresh,
            child: const Text('Refresh'),
          )
        ],
      ),
    );
  }
}

class NoDataWithoutTryAgain extends StatelessWidget {
  const NoDataWithoutTryAgain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _LottieNoDataWidget(),
              Text(
                context.loc.noDataDesc,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
