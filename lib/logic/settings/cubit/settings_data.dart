enum AppThemeMode {
  dark,
  light,
  system,
  auto,
  random,
}

enum AppLanguague {
  system(valueName: 'System'),
  en(valueName: 'English'),
  ar(valueName: 'العربية');

  const AppLanguague({required this.valueName});

  final String valueName;
}

enum AppThemeSystem {
  material3,
  material2,
  cupertino,
  fluentUi,
}

enum AppLayoutMode {
  auto,
  small,
  large,
}
