import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();

  factory NavigationService() => _instance;

  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  dynamic goBack([dynamic popValue]) {
    return navigationKey.currentState!.pop(popValue);
  }

  Future<dynamic> navigateToScreen(Widget page, {arguments}) async => navigationKey.currentState!.push(
    MaterialPageRoute(
      builder: (_) => page,
    ),
  );

  Future<dynamic> replaceScreen(Widget page, {arguments}) async => navigationKey.currentState!.pushReplacement(
    MaterialPageRoute(
      builder: (_) => page,
    ),
  );

  void popToFirst() => navigationKey.currentState!.popUntil((route) => route.isFirst);
}