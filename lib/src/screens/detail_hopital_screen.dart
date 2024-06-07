import 'package:flutter/material.dart';
import 'package:heathbridge_lao/package.dart';

class HospitalDetailScreen extends StatelessWidget {
  const HospitalDetailScreen({super.key});
  final int rating = 3;
  final int reviews = 40;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          const SizedBox(height: 15),
          const SizedBox(
            width: 120,
            child: Divider(
              color: Colors.grey,
              thickness: 4,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mahosot Hospital",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "ໂຮງໝໍມະໂຫສົດ",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text("($rating)",
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.grey)),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      height: 15,
                                      width: 75,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 5,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Icon(
                                            Icons.star,
                                            color: index < rating
                                                ? Colors.orange
                                                : Colors.grey,
                                            size: 15,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text("($reviews)",
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Text("Government hospital",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey))
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    icon: const Icon(Icons.directions),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text("Directions",
                                    style: TextStyle(fontSize: 13)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
