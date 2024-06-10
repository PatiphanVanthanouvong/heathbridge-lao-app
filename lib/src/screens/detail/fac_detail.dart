import 'package:flutter/material.dart';
import 'package:heathbridge_lao/package.dart';
import 'package:provider/provider.dart';
import 'package:heathbridge_lao/src/provider/facilities_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FacDetail extends StatefulWidget {
  const FacDetail({super.key, required this.facId});
  final String facId;

  @override
  State<FacDetail> createState() => _FacDetailState();
}

class _FacDetailState extends State<FacDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final int rating = 3;
  final int reviews = 40;

  @override
  Widget build(BuildContext context) {
    return Consumer<FacilityProvider>(builder: (context, provider, child) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 1.0,
        minChildSize: 0.5,
        shouldCloseOnMinExtent: true,
        builder: (context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: provider.isGettingDetails
                ? const Padding(
                    padding: EdgeInsets.all(100.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Divider(
                          color: Colors.grey,
                          thickness: 4,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 220,
                        width: double.infinity,
                        color: Colors.black,
                        child: provider.oneFac.imageUrl == null ||
                                provider.oneFac.imageUrl == ""
                            ? const Center(
                                child: Text(
                                  "No image yet",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Image.network(
                                provider.oneFac.imageUrl!,
                                fit: BoxFit.fitHeight,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return const Center(
                                    child: Text(
                                      "Failed to load image",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.oneFac.name ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${provider.oneFac.facilityType?.nameLa}  ${provider.oneFac.facilityType?.type}", // Assuming facilityTye has a nameLa field
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text("($rating)",
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey)),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          height: 15,
                                          width: 75,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (BuildContext context,
                                                int index) {
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
                                                fontSize: 13,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                                Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: IconButton(
                                        icon: const Icon(Icons.directions),
                                        color: Colors.white,
                                        onPressed: () {
                                          // Add directions logic here
                                        },
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

                      const Divider(),
                      // TabBar

                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: "Overview"),
                          Tab(text: "Review"),
                          Tab(text: "About"),
                        ],
                      ),
                      // TabBarView
                      SizedBox(
                        height: 730, // Adjust the height as needed
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_on),
                                        Text(
                                          "  Address:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "  ${provider.oneFac.village},  ${provider.oneFac.district},  ${provider.oneFac.province}.",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Icon(Icons.call),
                                        const Text(
                                          "  Contact Information:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          provider.oneFac.contactInfo == null ||
                                                  provider.oneFac.contactInfo ==
                                                      ""
                                              ? "No Contact Information"
                                              : provider.oneFac.contactInfo!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    const Row(
                                      children: [
                                        Icon(Icons.medical_services),
                                        Text(
                                          "  Services:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 0),
                                    provider.oneFac.serviceDetails == null ||
                                            provider
                                                .oneFac.serviceDetails!.isEmpty
                                        ? const Text(
                                            "No data",
                                            style: TextStyle(fontSize: 13),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: provider
                                                .oneFac.serviceDetails!
                                                .map((serviceDetail) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0),
                                                child: Text(
                                                  "${serviceDetail.service?.nameEn ?? 'No service name'} (${serviceDetail.service?.type ?? 'No service type'})",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                    const Divider(),
                                  ]),
                            ),
                            //* REVIEW SCREEN
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      " Rate & Review:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const CircleAvatar(
                                          radius: 16,
                                          child: Icon(Icons.person),
                                        ),
                                        RatingBar.builder(
                                          // ignoreGestures: true,
                                          initialRating: 5,
                                          minRating: 1,
                                          maxRating: 5,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 3.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            context.push("/review");
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 90,
                                      child: Card(
                                        color: Colors.black,
                                        elevation: 2,
                                        borderOnForeground: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                            //* ABOUT SCREEN
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      );
    });
  }
}
