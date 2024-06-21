import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InfoScreen'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('InfoScreen'),
      ),
    );
  }
}