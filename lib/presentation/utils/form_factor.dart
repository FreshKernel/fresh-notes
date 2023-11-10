import 'package:flutter/widgets.dart' show BuildContext, MediaQuery;

enum FormFactor {
  desktop(900),
  mobile(300),
  tablet(600);

  const FormFactor(this.breakpoint);

  final double breakpoint;
}

extension BuildContextExtensions on BuildContext {
  T withFormFactor<T>({
    required T mobile,
    required T tablet,
    required T desktop,
    bool useDeviceOrientation = true,
  }) {
    final formFactor =
        this.formFactor(useDeviceOrientation: useDeviceOrientation);

    switch (formFactor) {
      case FormFactor.desktop:
        return desktop;
      case FormFactor.mobile:
        return mobile;
      case FormFactor.tablet:
        return tablet;
    }
  }

  FormFactor formFactor({
    required bool useDeviceOrientation,
  }) {
    final size = MediaQuery.sizeOf(this);
    final width = useDeviceOrientation ? size.width : size.shortestSide;

    return width > FormFactor.desktop.breakpoint
        ? FormFactor.desktop
        : (width > FormFactor.tablet.breakpoint)
            ? FormFactor.tablet
            : FormFactor.mobile;
  }
}
