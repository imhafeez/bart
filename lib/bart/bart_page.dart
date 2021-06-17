import 'package:flutter/material.dart';

import 'bart_model.dart';

class MenuRouterDelegate extends RouterDelegate<MenuRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MenuRoutePath> {
  final List<BartMenuRoute> routes;
  final String? initialRoute;
  final List<NavigatorObserver>? navigatorObservers;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  PageRouteBuilder? _currentRoute, _oldRoute;

  MenuRouterDelegate(this.routes, this.initialRoute, this.navigatorObservers);

  void goPage(int n) {
    // if (routes[n].path == _currentRoute!.settings.name) return;
    navigatorKey.currentState!.pushNamed(routes[n].path);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        initialRoute: initialRoute ?? routes.first.path,
        onGenerateRoute: (RouteSettings settings) {
          var searchedRoute = routes.firstWhere((element) => element.path == settings.name, orElse: () => routes.first);
          _oldRoute = _currentRoute;
          _currentRoute = PageRouteBuilder(
              maintainState: searchedRoute.maintainState ?? true,
              settings: searchedRoute.settings,
              pageBuilder: (context, __, ___) => searchedRoute.pageBuilder(context),
              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c));
          if (navigatorObservers != null) {
            navigatorObservers!.forEach((element) {
              element.didPush(_currentRoute!, _oldRoute);
              // element.didReplace(newRoute: _currentRoute, oldRoute: _oldRoute);
            });
          }
          return _currentRoute;
        });
  }

  @override
  Future<void> setNewRoutePath(MenuRoutePath configuration) async {
    print("setNewRoutePath ${configuration.toString()}");
  }
}
