import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heathbridge_lao/firebase_options.dart';
import 'package:heathbridge_lao/package.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Initializing dotenv');
  try {
    await dotenv.load(fileName: ".env");
    print('Dotenv loaded successfully');
  } catch (e) {
    print("Error loading .env file: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => appLanguage),
        ChangeNotifierProvider(create: (_) => FacilityProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ConstantColor.colorMain),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
