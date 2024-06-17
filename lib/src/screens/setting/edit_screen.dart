import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heathbridge_lao/package.dart'; // Adjust this import as per your project structure

class EditProfileScreen extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModelList = userProvider.userModel;

    // Assuming editing the first user in the list
    final userModel = userModelList.isNotEmpty ? userModelList[0] : UserModel();

    _firstNameController.text = userModel.firstname ?? '';
    _lastNameController.text = userModel.lastname ?? '';
    _telController.text = userModel.tel ?? '';
    _emailController.text = userModel.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                UserModel updatedUser = UserModel(
                  userId: userModel.userId,
                  firstname: _firstNameController.text,
                  lastname: _lastNameController.text,
                  tel: _telController.text,
                  email: _emailController.text,
                  firebaseId: userModel.firebaseId,
                );
                userProvider.updateUser(
                    updatedUser); // Update user using provider method
                Navigator.pop(context); // Navigate back after update
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
