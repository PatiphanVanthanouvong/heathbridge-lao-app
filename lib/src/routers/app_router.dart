import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/screens/review/review_screen.dart';
import 'package:heathbridge_lao/src/screens/search_screen.dart';

import '../screens/login/sign_in_screen.dart';
import '../screens/login/sign_up_screen.dart';
import 'package:heathbridge_lao/src/screens/home/search_screen.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/controller_page',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: "/signin", builder: (context, state) => const SignInScreen()),
    GoRoute(path: "/review", builder: (context, state) => const ReviewScreen()),
    GoRoute(path: "/signup", builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: "/setpassword/:firstname/:lastname/:email/:tel/:gender",
      builder: (BuildContext context, GoRouterState state) {
        String? firstname = state.pathParameters['firstname'];
        String? lastname = state.pathParameters['lastname'];
        String? email = state.pathParameters['email'];
        String? tel = state.pathParameters['tel'];
        String? gender = state.pathParameters['gender'];
        return SetPasswordScreen(
          firstname: firstname ?? '',
          lastname: lastname ?? '',
          email: email ?? '',
          tel: tel ?? '',
          gender: gender ?? '',
        );
      },
    ),
    GoRoute(
        path: "/controller_page",
        builder: (context, state) => const ControllerPage()),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: "/otp/:verificationId",
      builder: (BuildContext context, GoRouterState state) {
        String? verificationId = state.pathParameters['verificationId'];
        return OtpScreen(verificationId: verificationId.toString());
      },
    )
  ],
);
