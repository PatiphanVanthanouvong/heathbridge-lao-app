import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/screens/information/info_screen.dart';
import 'package:heathbridge_lao/src/screens/list/list_screen.dart'; // Assuming this package provides HomeScreen, SettingScreen, and ConstantColor

class ControllerPage extends StatefulWidget {
  const ControllerPage({super.key});

  @override
  State<ControllerPage> createState() => _NaviPageState();
}

class _NaviPageState extends State<ControllerPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ListSearch(),
    InfoScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserProvider>().userModel;
    debugPrint("User Model Data: $userModel");
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: SizedBox(
          height: 65,
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                selectedIcon: Icon(
                  // width: 23,
                  // height: 23,
                  Icons.home, size: 30,
                ),
                icon: Icon(
                  // width: 23,
                  // height: 23,
                  Icons.home_outlined, size: 30,
                ),
                label: 'ໜ້າຫຼັກ',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  // width: 23,
                  // height: 23,
                  Icons.view_list, size: 30,
                ),
                icon: Icon(
                  // width: 23,
                  // height: 23,
                  Icons.view_list_outlined, size: 30,
                ),
                label: 'ການຄົ້ນຫາ',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.info,
                  size: 30,
                ),
                icon: Icon(
                  Icons.info_outline,
                  size: 30,
                ),
                label: 'ຂໍ້ມູນເພີ່ມເຕີມ',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  // width: 23,
                  // height: 23,
                  Icons.settings, size: 30,
                ),
                icon: Icon(
                  // width: 23,
                  // height: 23,
                  Icons.settings_outlined, size: 30,
                ),
                label: 'ຕັ້ງຄ່າ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
