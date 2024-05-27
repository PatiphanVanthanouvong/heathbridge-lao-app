import 'package:heathbridge_lao/package.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: "/signin", builder: (context, state) => const SignInScreen()),
    GoRoute(path: "/signup", builder: (context, state) => const SignUpScreen()),
    GoRoute(
        path: "/setpassword",
        builder: (context, state) => const SetPasswordScreen()),
    GoRoute(path: "/controller_page", builder: (context, state) => const ControllerPage()),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
  ],
);
