//https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
import 'package:flutter/cupertino.dart';

import '../services/state_service.dart';


class StateContainer extends InheritedWidget {
  StateContainer({
    super.key,
    required this.stateService,
    required super.child,
  });

  final StateService stateService;

  @override
  bool updateShouldNotify(StateContainer oldWidget) {
    return stateService != oldWidget.stateService;
  }

  static StateContainer? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StateContainer>();
  }

  static StateContainer of(BuildContext context) {
    final StateContainer? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }
}