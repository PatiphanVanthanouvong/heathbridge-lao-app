import 'package:heathbridge_lao/package.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ControllerPage(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) => const HospitalDetailPage(),
    )
  ],
);

