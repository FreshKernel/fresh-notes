/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/images/app_logo.png');

  /// File path: assets/images/macos_notes_crash.webp
  AssetGenImage get macosNotesCrash =>
      const AssetGenImage('assets/images/macos_notes_crash.webp');

  /// List of all assets
  List<AssetGenImage> get values => [appLogo, macosNotesCrash];
}

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// File path: assets/json/story.json
  String get story => 'assets/json/story.json';

  /// List of all assets
  List<String> get values => [story];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  $AssetsLottieErrorGen get error => const $AssetsLottieErrorGen();
  $AssetsLottieNoDataGen get noData => const $AssetsLottieNoDataGen();
  $AssetsLottieNoInternetGen get noInternet =>
      const $AssetsLottieNoInternetGen();
  $AssetsLottieOnboardingGen get onboarding =>
      const $AssetsLottieOnboardingGen();
  $AssetsLottiePageNotFoundGen get pageNotFound =>
      const $AssetsLottiePageNotFoundGen();
}

class $AssetsLottieErrorGen {
  const $AssetsLottieErrorGen();

  /// File path: assets/lottie/error/error_1.json
  LottieGenImage get error1 =>
      const LottieGenImage('assets/lottie/error/error_1.json');

  /// List of all assets
  List<LottieGenImage> get values => [error1];
}

class $AssetsLottieNoDataGen {
  const $AssetsLottieNoDataGen();

  /// File path: assets/lottie/no_data/no_data_1.json
  LottieGenImage get noData1 =>
      const LottieGenImage('assets/lottie/no_data/no_data_1.json');

  /// File path: assets/lottie/no_data/no_data_2.json
  LottieGenImage get noData2 =>
      const LottieGenImage('assets/lottie/no_data/no_data_2.json');

  /// List of all assets
  List<LottieGenImage> get values => [noData1, noData2];
}

class $AssetsLottieNoInternetGen {
  const $AssetsLottieNoInternetGen();

  /// File path: assets/lottie/no_internet/no_internet_1.json
  LottieGenImage get noInternet1 =>
      const LottieGenImage('assets/lottie/no_internet/no_internet_1.json');

  /// File path: assets/lottie/no_internet/no_internet_2.json
  LottieGenImage get noInternet2 =>
      const LottieGenImage('assets/lottie/no_internet/no_internet_2.json');

  /// File path: assets/lottie/no_internet/no_internet_3.json
  LottieGenImage get noInternet3 =>
      const LottieGenImage('assets/lottie/no_internet/no_internet_3.json');

  /// List of all assets
  List<LottieGenImage> get values => [noInternet1, noInternet2, noInternet3];
}

class $AssetsLottieOnboardingGen {
  const $AssetsLottieOnboardingGen();

  /// File path: assets/lottie/onboarding/cloud.json
  LottieGenImage get cloud =>
      const LottieGenImage('assets/lottie/onboarding/cloud.json');

  /// File path: assets/lottie/onboarding/cloud_data.json
  LottieGenImage get cloudData =>
      const LottieGenImage('assets/lottie/onboarding/cloud_data.json');

  /// File path: assets/lottie/onboarding/cross_platform.json
  LottieGenImage get crossPlatform =>
      const LottieGenImage('assets/lottie/onboarding/cross_platform.json');

  /// File path: assets/lottie/onboarding/customizable_settings.json
  LottieGenImage get customizableSettings => const LottieGenImage(
      'assets/lottie/onboarding/customizable_settings.json');

  /// File path: assets/lottie/onboarding/open_source.json
  LottieGenImage get openSource =>
      const LottieGenImage('assets/lottie/onboarding/open_source.json');

  /// File path: assets/lottie/onboarding/privacy_protection.json
  LottieGenImage get privacyProtection =>
      const LottieGenImage('assets/lottie/onboarding/privacy_protection.json');

  /// File path: assets/lottie/onboarding/type_notes.json
  LottieGenImage get typeNotes =>
      const LottieGenImage('assets/lottie/onboarding/type_notes.json');

  /// File path: assets/lottie/onboarding/under_development.json
  LottieGenImage get underDevelopment =>
      const LottieGenImage('assets/lottie/onboarding/under_development.json');

  /// List of all assets
  List<LottieGenImage> get values => [
        cloud,
        cloudData,
        crossPlatform,
        customizableSettings,
        openSource,
        privacyProtection,
        typeNotes,
        underDevelopment
      ];
}

class $AssetsLottiePageNotFoundGen {
  const $AssetsLottiePageNotFoundGen();

  /// File path: assets/lottie/page_not_found/page_not_found_1.json
  LottieGenImage get pageNotFound1 => const LottieGenImage(
      'assets/lottie/page_not_found/page_not_found_1.json');

  /// File path: assets/lottie/page_not_found/page_not_found_2.json
  LottieGenImage get pageNotFound2 => const LottieGenImage(
      'assets/lottie/page_not_found/page_not_found_2.json');

  /// List of all assets
  List<LottieGenImage> get values => [pageNotFound1, pageNotFound2];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsJsonGen json = $AssetsJsonGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class LottieGenImage {
  const LottieGenImage(this._assetName);

  final String _assetName;

  LottieBuilder lottie({
    Animation<double>? controller,
    bool? animate,
    FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    LottieDelegates? delegates,
    LottieOptions? options,
    void Function(LottieComposition)? onLoaded,
    LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, LottieComposition?)? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    String? package,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
  }) {
    return Lottie.asset(
      _assetName,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
