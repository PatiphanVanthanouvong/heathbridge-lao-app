import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/screens/home/search_screen.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: "/signin", builder: (context, state) => const SignInScreen()),
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
        path: "/navigation",
        builder: (context, state) => const Navigation()),
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
