import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/provider/facilities_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => appLanguage),
        ChangeNotifierProvider(create: (_) => FacilityProvider()),
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
