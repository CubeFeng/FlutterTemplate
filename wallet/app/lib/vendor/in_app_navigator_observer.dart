import 'package:flutter/widgets.dart';

class InAppNavigatorObserver extends NavigatorObserver {
  static final _instance = InAppNavigatorObserver._();

  factory InAppNavigatorObserver() => _instance;

  final _listeners = <InAppRouteListener>[];

  InAppNavigatorObserver._();

  void addListener(InAppRouteListener listener) {
    _listeners.add(listener);
  }

  void removeListener(InAppRouteListener listener) {
    _listeners.remove(listener);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    for (var listener in _listeners) {
      listener.didInAppRoutePush(route, previousRoute);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    for (var listener in _listeners) {
      listener.didInAppRoutePop(route, previousRoute);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    for (var listener in _listeners) {
      listener.didInAppRouteRemove(route, previousRoute);
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    for (var listener in _listeners) {
      listener.didInAppRouteReplace(newRoute: newRoute, oldRoute: oldRoute);
    }
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    for (var listener in _listeners) {
      listener.didInAppRouteStartUserGesture(route, previousRoute);
    }
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    for (var listener in _listeners) {
      listener.didInAppRouteStopUserGesture;
    }
  }
}

abstract class InAppRouteListener {
  void didInAppRoutePush(Route route, Route? previousRoute) {}

  void didInAppRoutePop(Route route, Route? previousRoute) {}

  void didInAppRouteRemove(Route route, Route? previousRoute) {}

  void didInAppRouteReplace({Route? newRoute, Route? oldRoute}) {}

  void didInAppRouteStartUserGesture(Route route, Route? previousRoute) {}

  void didInAppRouteStopUserGesture() {}
}
