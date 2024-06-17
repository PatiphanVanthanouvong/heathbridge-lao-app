import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:heathbridge_lao/package.dart';

import 'edit_screen.dart';
import 'widgets/user_card.dart'; // Import the package where UserProvider and UserModel are defined

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the user data when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        context.read<UserProvider>().fetchUser(firebaseUser.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("ຕັ້ງຄ່າ"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showLogoutConfirmationDialog,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Text(
                "ທົ່ວໄປ",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<UserProvider>(
                            builder: (context, userProvider, child) {
                              if (userProvider.userModel.isEmpty) {
                                return Text(
                                  'Logged in as a Anonymous User',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                );
                              } else {
                                final user = userProvider.userModel.first;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${user.firstname} ${user.lastname}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.arrow_right_alt),
                                    ),
                                    Text(
                                      'Phone Number: ${user.tel}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Text(
                "General",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ListTile(
                title: const Row(
                  children: [
                    Text('ລາຍລະອຽດຜູ້ໃຊ້ງານ'),
                    SizedBox(width: 8),
                  ],
                ),
                onTap: () {
                  // Navigate to About Us screen
                },
                trailing: const Icon(Icons.info_outline),
              ),
              const Divider(),
              Text(
                "Appearance",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ListTile(
                title: const Row(
                  children: [
                    Text('About Us'),
                    SizedBox(width: 8),
                    Icon(Icons.info_outline),
                  ],
                ),
                onTap: () {
                  // Navigate to About Us screen
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void handleLogout(BuildContext context) {
    context.read<UserProvider>().logout();
  }

  // Function to show logout confirmation dialog
  void _showLogoutConfirmationDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: 'Logout',
      desc: 'Are you sure you want to logout?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        handleLogout(context);
        FirebaseAuth.instance.signOut();
        context.pushReplacement('/signin');
      },
    ).show();
  }
}
