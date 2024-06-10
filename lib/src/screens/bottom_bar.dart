import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heathbridge_lao/package.dart';
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
          height: 60,
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
                label: 'Search',
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
