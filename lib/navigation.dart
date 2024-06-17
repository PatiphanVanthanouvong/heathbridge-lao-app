import 'package:heathbridge_lao/package.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  void _checkAuth() {
    var auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      context.go("/");
    }
  }

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
          height: 91,
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: SizedBox(
                  width: 23,
                  height: 23,
                  child: SvgPicture.asset(
                    'assets/icons/home-icon.svg',
                    color: ConstantColor.colorMain,
                  ),
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: SizedBox(
                  width: 23,
                  height: 23,
                  child: SvgPicture.asset(
                    'assets/icons/setting-icon.svg',
                    color: ConstantColor.colorMain,
                  ),
                ),
                label: 'Setting',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
