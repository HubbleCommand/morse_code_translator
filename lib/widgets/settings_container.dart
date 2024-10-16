//https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
import 'package:flutter/cupertino.dart';

import '../services/settings_service.dart';

class SettingsContainer extends InheritedWidget {
  SettingsContainer({
    super.key,
    required this.settingsService,
    required super.child,
  });

  final SettingsService settingsService;

  @override
  bool updateShouldNotify(SettingsContainer oldWidget) {
    return settingsService != oldWidget.settingsService;
  }

  static SettingsContainer? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsContainer>();
  }

  static SettingsContainer of(BuildContext context) {
    final SettingsContainer? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }
}