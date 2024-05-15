import 'package:heathbridge_lao/src/constants/consts.dart';
import 'package:heathbridge_lao/src/models/map_marker_model.dart';
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
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      body: Stack(
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
              ),
              MarkerLayer(
                markers: [
                  for (int i = 0; i < mapMarkers.length; i++)
                    Marker(
                      height: 40,
                      width: 40,
                      point: mapMarkers[i].location ?? AppConstants.myLocation,
                      child: GestureDetector(
                        onTap: () {
                          pageController.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          selectedIndex = i;
                          currentLocation =
                              mapMarkers[i].location ?? AppConstants.myLocation;
                          _animatedMapMove(currentLocation, 14);
                          setState(() {});
                        },
                        child: GestureDetector(
                          onDoubleTap: () {
                            showBottomSheet(
                                context: context,
                                builder: (ctx) => const HospitalDetailScreen());
                          },
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 500),
                            scale: selectedIndex == i ? 1 : 0.7,
                            child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: selectedIndex == i ? 1 : 0.5,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                )),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
                currentLocation =
                    mapMarkers[value].location ?? AppConstants.myLocation;
                _animatedMapMove(currentLocation, 14);
                setState(() {});
              },
              itemCount: mapMarkers.length,
              itemBuilder: (_, index) {
                final item = mapMarkers[index];
                return Card(
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
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title ?? '',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Row(children: [
                                SvgPicture.asset(
                                    "assets/icons/calling-icon.svg"),
                                const SizedBox(width: 5),
                                Text(
                                  item.contact ?? '',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 15,
            bottom: 280, // Adjust as needed
            child: Center(
              child: InkWell(
                onTap: () {
                  _animatedMapMove(AppConstants.myLocation, 14);
                  // context.push("/detail");
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child:
                      SvgPicture.asset("assets/icons/location-targer-icon.svg"),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 1.2,
            top: 15,
            left: 20,
            child: InkWell(
                onTap: () {
                  context.push("/search");
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TextField(
                      //   enabled: false,
                      //   decoration: InputDecoration(
                      //     prefixIcon: Icon(Icons.search),
                      //     hintText: 'Search...',
                      //     filled: true,
                      //     fillColor: Colors.white, // Background color
                      //     border: OutlineInputBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(10.0)),
                      //       borderSide: BorderSide(
                      //         color: ConstantColor.colorMain, // Border color
                      //         width: 2.0, // Border width
                      //       ),
                      //     ),
                      //     isDense: true,
                      //     disabledBorder: OutlineInputBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(40.0)),
                      //       borderSide: BorderSide(
                      //         color: ConstantColor
                      //             .colorMain, // Border color when disabled
                      //         width: 2.0, // Border width
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
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
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
