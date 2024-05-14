import 'package:heathbridge_lao/package.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({super.key});

  @override
  State<ControllerPage> createState() => _NaviPageState();
}

class _NaviPageState extends State<ControllerPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/home-icon.svg',
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset(
                    'assets/icons/setting-icon.svg',
                  ),
                ),
                label: "Setting",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
