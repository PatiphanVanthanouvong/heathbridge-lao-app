import 'package:flutter/material.dart';
import 'package:heathbridge_lao/package.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController reviewTextController = TextEditingController();

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: ConstantColor.colorMain,
      minimumSize: const Size(double.infinity, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('ReviewScreen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: const CircleAvatar()),
                title: const Text(
                  'No Name',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "wwww",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.info_outline),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextFormField(
                  controller: reviewTextController,
                  minLines: 4,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    hintText: 'Share your thoughts about this facility',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {},
                child: const Text('Post Review'),
              )
            ],
          ),
        ));
  }
}
