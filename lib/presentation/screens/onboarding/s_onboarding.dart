import 'package:flutter/material.dart'
    show Brightness, Colors, Scaffold, TextButton, Theme;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../gen/assets.gen.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../l10n/extensions/localizations.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/on-boarding';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late final PageController _controller;
  var _isLastPageReached = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPage({
    required Color color,
    required String imagePath,
    required String title,
    required String subtitle,
  }) =>
      Semantics(
        label: title,
        child: Container(
          color: color,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: 325,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.noScaling,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.teal.shade700,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildPage(
        color: Colors.blue.shade100,
        imagePath: Assets.lottie.onboarding.typeNotes.path,
        title: context.loc.richTextEditing,
        subtitle: context.loc.richTextEditingOboardingDesc,
      ),
      _buildPage(
        color: Colors.green.shade100,
        imagePath: Assets.lottie.onboarding.openSource.path,
        title: context.loc.freeAndOpenSource,
        subtitle: context.loc.freeAndOpenSourceOboardingDesc,
      ),
      _buildPage(
        color: Colors.orange.shade100,
        imagePath: Assets.lottie.onboarding.crossPlatform.path,
        title: context.loc.crossPlatform,
        subtitle: context.loc.crossPlatformOnBoardingDesc,
      ),
      _buildPage(
        color: Colors.greenAccent.shade100,
        imagePath: Assets.lottie.onboarding.cloud.path,
        title: context.loc.saveLocallyAndToTheCloud,
        subtitle: context.loc.saveLocallyAndToTheCloudOnBoardingDesc,
      ),
      _buildPage(
        color: Colors.teal.shade100,
        imagePath: Assets.lottie.onboarding.privacyProtection.path,
        title: context.loc.privacyProtection,
        subtitle: context.loc.privacyProtectionOnBoardingDesc,
      ),
      _buildPage(
        color: Colors.red.shade100,
        imagePath: Assets.lottie.onboarding.customizableSettings.path,
        title: context.loc.customizableSettings,
        subtitle: context.loc.customizableSettingsOnBoardingDesc,
      ),
      // _buildPage(
      //   color: Colors.yellow.shade100,
      //   imagePath: Assets.lottie.support1.path,
      //   title: translations.in_app_support_chat_feature,
      //   subtitle: translations.in_app_support_chat_feature_details,
      // ),
      _buildPage(
        color: Colors.green.shade100,
        imagePath: Assets.lottie.onboarding.underDevelopment.path,
        title: context.loc.underActiveDevelopment,
        subtitle: context.loc.underActiveDevelopmentOnBoardingDesc,
      ),
    ];

    return Semantics(
      label: 'Welcome!',
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  if (index != pages.length - 1) return;
                  setState(() => _isLastPageReached = true);
                },
                controller: _controller,
                children: pages,
              ),
            ),
            Container(
              padding: _isLastPageReached
                  ? null
                  : const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: _isLastPageReached
                  ? Semantics(
                      label: 'Get Started',
                      child: TextButton(
                        onPressed: () async {
                          final settingsBloc = context.read<SettingsCubit>();
                          settingsBloc.showOnBoardingScreen(false);
                        },
                        style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          minimumSize: const Size(double.infinity, 80),
                        ),
                        child: const Text('Get Started'),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Semantics(
                          label: 'Skip',
                          child: TextButton(
                            child: const Text('Skip'),
                            onPressed: () =>
                                _controller.jumpToPage(pages.length - 1),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SmoothPageIndicator(
                              controller: _controller,
                              count: pages.length,
                              onDotClicked: (index) =>
                                  _controller.animateToPage(index,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn),
                              effect: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const WormEffect(
                                      dotHeight: 20,
                                      dotWidth: 20,
                                    )
                                  : WormEffect(
                                      dotColor: Colors.black26,
                                      dotHeight: 20,
                                      dotWidth: 20,
                                      activeDotColor: Colors.teal.shade700,
                                    ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: 'Next',
                          child: TextButton(
                            child: const Text('Next'),
                            onPressed: () => _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
