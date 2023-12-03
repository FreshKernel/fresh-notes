import 'package:flutter/material.dart'
    show Brightness, Colors, Scaffold, TextButton, Theme;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../gen/assets.gen.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../dashboard/s_dashboard.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/onBoarding';

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
                    width: 400,
                  ),
                  const SizedBox(height: 64),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
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
        title: 'Rich Text Editing',
        subtitle:
            'Format your notes with ease using a variety of text styling options for a personalized touch.',
      ),
      _buildPage(
        color: Colors.green.shade100,
        imagePath: Assets.lottie.onboarding.openSource.path,
        title: 'Free and Open Source',
        subtitle:
            'Enjoy the app without any cost and benefit from transparency in development.',
      ),
      _buildPage(
        color: Colors.orange.shade100,
        imagePath: Assets.lottie.onboarding.crossPlatform.path,
        title: 'Cross-Platform',
        subtitle:
            'Access your notes seamlessly on various devices and platforms.',
      ),
      _buildPage(
        color: Colors.greenAccent.shade100,
        imagePath: Assets.lottie.onboarding.cloud.path,
        title: 'Save to Local and Cloud',
        subtitle:
            'Securely store your notes locally on your device or sync them to the cloud for easy access.',
      ),
      _buildPage(
        color: Colors.teal.shade100,
        imagePath: Assets.lottie.onboarding.privacyProtection.path,
        title: 'Privacy Protection',
        subtitle:
            'Your notes are kept private and secure with advanced encryption and privacy features.',
      ),
      _buildPage(
        color: Colors.red.shade100,
        imagePath: Assets.lottie.onboarding.customizableSettings.path,
        title: 'Customizable Settings',
        subtitle:
            'Tailor the app to your preferences with a range of customizable settings and options.',
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
        title: 'Under active development',
        subtitle:
            'Thank you for using the app! Please note that we are still working to improve your experience.',
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
