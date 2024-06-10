import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/screens/review/review_screen.dart';
import 'package:heathbridge_lao/src/screens/search_screen.dart';

import '../screens/login/sign_in_screen.dart';
import '../screens/login/sign_up_screen.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (context, state) => const ControllerPage()),
    GoRoute(
      path: '/controller_page',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: "/signin", builder: (context, state) => const SignInScreen()),
    GoRoute(path: "/review", builder: (context, state) => const ReviewScreen()),
    GoRoute(path: "/signup", builder: (context, state) => const SignUpScreen()),
    GoRoute(
        path: "/setpassword",
        builder: (context, state) => const SetPasswordScreen()),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
  ],
);
