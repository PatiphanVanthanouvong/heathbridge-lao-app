import 'package:heathbridge_lao/package.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.5,
  );
  var currentLocation = AppConstants.myLocation;

  int selectedIndex = 0;

  late final MapController mapController;
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacilityProvider>().getFacInfo();
    });
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

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.height);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Adjust the height as needed
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove elevation if not needed
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
              child: const TextField(
                enabled: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<FacilityProvider>(builder: (context, provider, child) {
        if (provider.isGettingFacInfo) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.facData.isEmpty) {
          return const Center(
            child: Text('No facilities found'),
          );
        }
        final markers = provider.facData.map(
          (facility) {
            final lat = double.tryParse(facility.latitude ?? '0') ?? 0;
            final lng = double.tryParse(facility.longitude ?? '0') ?? 0;
            final location = LatLng(lat, lng);
            // Define the default icon color
            Color iconColor = Colors.black;

            // Check the facility type and update the icon color accordingly
            if (facility.facilityType!.nameEn?.toLowerCase() == 'hospital') {
              iconColor = Colors.green;
            } else if (facility.facilityType!.nameEn?.toLowerCase() ==
                'pharmacy') {
              iconColor = Colors.blue;
            } else if (facility.facilityType!.nameEn?.toLowerCase() ==
                'clinic') {
              iconColor = Colors.yellow;
            }
            return Marker(
              height: 40,
              width: 40,
              point: location,
              // Use child directly instead of builder
              child: GestureDetector(
                onTap: () {
                  final index = provider.facData.indexOf(facility);
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                  selectedIndex = index;
                  currentLocation = location;
                  _animatedMapMove(currentLocation, 14);
                  setState(() {});
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
                    child: Icon(Icons.location_on, color: iconColor, size: 38),
                  ),
                ),
              ),
            );
          },
        ).toList();
        return Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                  minZoom: 5,
                  maxZoom: 18,
                  initialZoom: 14,
                  initialCenter: currentLocation),
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 100,
              height: MediaQuery.of(context).size.height * 0.2,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  selectedIndex = value;
                  final facility = provider.facData[value];
                  currentLocation = LatLng(
                    double.tryParse(facility.latitude ?? '0') ?? 0,
                    double.tryParse(facility.longitude ?? '0') ?? 0,
                  );
                  _animatedMapMove(currentLocation, 14);
                  setState(() {});
                },
                itemCount: provider.facData.length,
                itemBuilder: (_, index) {
                  final facility = provider.facData[index];
                  return GestureDetector(
                    onTap: () {
                      print("run funtions");
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Container(
                                height: 90,
                                width: double.infinity,
                                color: Colors.white,
                                child: facility.imageUrl == null ||
                                        facility.imageUrl == ""
                                    ? const Center(
                                        child: Text(
                                          "No image yet",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : Image.network(
                                        facility.imageUrl!,
                                        fit: BoxFit.scaleDown,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
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
                                              "Failed to load image",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
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
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    facility.name ?? '',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        facility.facilityType?.type ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        facility.facilityType?.nameEn ?? '',
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
            ),
            Positioned(
              right: 15,
              bottom: 280,
              child: Center(
                child: InkWell(
                  onTap: () {
                    _animatedMapMove(AppConstants.myLocation, 14);
                    // context.push("/detail");
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
}
