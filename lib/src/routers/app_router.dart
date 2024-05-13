import 'package:heathbridge_lao/package.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ControllerPage(),
    ),
  ],
);

