// ignore_for_file: deprecated_member_use
import 'dart:developer';
import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/models/facility_type.model.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.5,
  );
  final bool _isDialogShown = false;
  var currentLocation = AppConstants.myLocation;
  LatLng? userLocation;
  int selectedIndex = 0;
  String _location = "Fetching location...";

  late final MapController mapController;
  @override
  void initState() {
    super.initState();
    _getLocation();
    mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacilityProvider>().getFacInfo();
      context.read<FacTypeProvider>().getFacType();
    });
    userLocation = currentLocation;
  }

  Future<void> _getLocation() async {
    log("TESt");
    try {
      log("try_get_location");
      Position position = await LocationService().getCurrentLocation();
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        // currentLocation = userLocation!;
        _location = "Lat: ${position.latitude}, Long: ${position.longitude}";
        log(_location);
        // Move the map to the user's current location
        mapController.move(currentLocation, 14);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  // void _showLoadingDialog(BuildContext context) {
  //   if (!_isDialogShown) {
  //     _isDialogShown = true;
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return const Dialog(
  //             child: Padding(
  //               padding: EdgeInsets.all(20.0),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   CircularProgressIndicator(),
  //                   SizedBox(width: 20),
  //                   Text("Loading..."),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       ).then((_) {
  //         // Ensure to reset the flag after dialog is dismissed
  //         if (mounted) {
  //           // Check if the state is still mounted before calling setState
  //           setState(() {
  //             _isDialogShown = false;
  //           });
  //         }
  //       });
  //     });
  //   }
  // }

  // void _hideLoadingDialog(BuildContext context) {
  //   if (_isDialogShown) {
  //     _isDialogShown = false;
  //     if (Navigator.of(context, rootNavigator: true).canPop()) {
  //       Navigator.of(context, rootNavigator: true).pop();
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: ConstantColor.colorMain,
                      width: 2.0,
                    ),
                  ),
                  width: 50,
                  height: 50,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                  ),
                ),
              ],
              title: InkWell(
                onTap: () {
                  context.push("/search");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: ConstantColor.colorMain,
                      width: 2.0,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    // onSubmitted: _searchController.text,

                    enabled: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ຄົ້ນຫາສະຖານທີ່...',
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50, // Adjust height as needed
              child: Consumer<FacTypeProvider>(
                  builder: (context, provider, child) {
                if (provider.isGettingService) {
                  return const Center(
                    child: Text('Loading....'),
                  );
                }
                if (provider.typeList.isEmpty) {
                  return const Center(
                    child: Text('No facility types available'),
                  );
                }
                String selectTypeName = 'ທັງໝົດ';
                String selectedType = 'ທັງໝົດ';
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  // itemCount: provider.typeList.length, // Number of chips
                  itemCount: AppConstants().factype.length,
                  itemBuilder: (BuildContext context, int index) {
                    FacTypeModel facility = provider.typeList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () async {
                          var query = AppConstants().factype[index];
                          var selectTypeName = AppConstants().factype[index];
                          await context
                              .read<FacilityProvider>()
                              .searchFacilities(
                                  selectTypeName == query || query == "ທັງໝົດ"
                                      ? ""
                                      : query,
                                  selectTypeName == "ທັງໝົດ"
                                      ? ""
                                      : selectTypeName,
                                  facilityTypes: selectedType == "ທັງໝົດ"
                                      ? null
                                      : [selectedType.toLowerCase()]);
                          _searchController.text = query;
                        },
                        // child: Chip(
                        //   label: Text("${facility.nameLa} ${facility.type}"),
                        // ),
                        child: Chip(label: Text(AppConstants().factype[index])),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      body: Consumer<FacilityProvider>(builder: (context, provider, child) {
        final markers = provider.facData.map((facility) {
          final lat = double.tryParse(facility.latitude ?? '0') ?? 0;
          final lng = double.tryParse(facility.longitude ?? '0') ?? 0;
          final location = LatLng(lat, lng);
          String markerImage;

          if (facility.facilityType?.nameEn?.toLowerCase() == 'hospital') {
            markerImage = 'assets/images/hospitol-marker.png';
          } else if (facility.facilityType?.nameEn?.toLowerCase() ==
              'pharmacy') {
            markerImage = 'assets/images/pharmacy-marker.png';
          } else if (facility.facilityType?.nameEn?.toLowerCase() == 'clinic') {
            markerImage = 'assets/images/clinic-marker.png';
          } else {
            markerImage =
                'assets/images/default-marker.png'; // Default image if needed
          }
          return Marker(
            height: 50,
            width: 50,
            point: location,
            child: GestureDetector(
              onTap: () {
                final index = provider.facData.indexOf(facility);
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
                setState(() {
                  selectedIndex = index;
                  currentLocation = location;
                });
                _animatedMapMove(currentLocation, 14);
              },
              onDoubleTap: () {
                context
                    .read<FacilityProvider>()
                    .getDetailEach(facId: facility.facId!);
                showBottomSheet(
                  context: context,
                  builder: (ctx) => FacDetail(facId: facility.facId!),
                );
              },
              child: AnimatedScale(
                duration: const Duration(milliseconds: 500),
                scale: selectedIndex == provider.facData.indexOf(facility)
                    ? 1
                    : 0.7,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: selectedIndex == provider.facData.indexOf(facility)
                      ? 1
                      : 0.5,
                  child: Image.asset(markerImage, fit: BoxFit.contain),
                ),
              ),
            ),
          );
        }).toList();
        if (userLocation != null) {
          markers.add(
            Marker(
                height: 50,
                width: 50,
                point: userLocation!,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 30,
                )),
          );
        }
        return Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                minZoom: 5,
                maxZoom: 18,
                initialZoom: 13,
                initialCenter: currentLocation,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/shokoon/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                  additionalOptions: const {
                    'accessToken':
                        "pk.eyJ1Ijoic2hva29vbiIsImEiOiJjbHJvbDMwMGgxMGcxMnFxanEzcmd2aHRtIn0.MtR09PVeAegNhumGfXcppA",
                    'mapStyleId': "clrom0wu7007i01pe7quyey3t",
                  },
                  tileProvider: NetworkTileProvider(),
                ),
                MarkerLayer(markers: markers),
              ],
            ),
            Consumer<FacilityProvider>(builder: (context, provider, child) {
              if (provider.isGettingFacInfo) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (provider.facData.isEmpty) {
                return const Center(
                  child: Text('ບໍ່ພົບສະຖານທີ່ທີ່ຄົ້ນຫາ'),
                );
              }
              return Positioned(
                left: 0,
                right: 0,
                bottom: 75,
                height: MediaQuery.of(context).size.height * 0.2,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      selectedIndex = value;
                      final facility = provider.facData[value];
                      currentLocation = LatLng(
                        double.tryParse(facility.latitude ?? '0') ?? 0,
                        double.tryParse(facility.longitude ?? '0') ?? 0,
                      );
                    });
                    _animatedMapMove(currentLocation, 14);
                  },
                  itemCount: provider.facData.length,
                  itemBuilder: (_, index) {
                    final facility = provider.facData[index];
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<FacilityProvider>()
                            .getDetailEach(facId: facility.facId!);
                        showBottomSheet(
                          context: context,
                          builder: (ctx) => FacDetail(facId: facility.facId!),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Container(
                                  height: 90,
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: facility.imageUrl == null ||
                                          facility.imageUrl == ""
                                      ? const Center(
                                          child: Text(
                                            "ຍັງບໍ່ມີຮູບພາບ",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        )
                                      : Image.network(
                                          facility.imageUrl!,
                                          fit: BoxFit.fitWidth,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return const Center(
                                              child: Text(
                                                "ຮູບມີການຜິດພາດ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    Text(
                                      facility.name ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          facility.facilityType?.nameLa ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          facility.facilityType?.sub_type ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            Positioned(
              right: 15,
              bottom: 235,
              child: Center(
                child: InkWell(
                  onTap: () {
                    _animatedMapMove(currentLocation, 14);
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                        "assets/icons/location-targer-icon.svg"),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
