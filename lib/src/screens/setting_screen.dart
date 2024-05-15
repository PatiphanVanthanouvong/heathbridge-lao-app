import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/provider/facilities_provider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the facilities data when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacilityProvider>().getFacInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facilities'),
      ),
      body: Consumer<FacilityProvider>(
        builder: (context, provider, child) {
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

          return ListView.builder(
            itemCount: provider.facData.length,
            itemBuilder: (context, index) {
              final facility = provider.facData[index];
              return ListTile(
                title: Text(facility.name ?? 'No Name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Province: ${facility.province ?? 'No Province'}'),
                    Text('Lat: ${facility.latitude ?? 'No Lat'}'),
                    Text('Lng: ${facility.longitude ?? 'No Lng'}'),
                    Text('Type: ${facility.facilityType?.nameEn ?? 'No Type'}'),
                    Text(
                        'Type (Local): ${facility.facilityType?.nameLa ?? 'No Type'}'),
                    Text(
                        'Type Description: ${facility.facilityType?.type ?? 'No Description'}'),
                    Text(
                        'Type Description: ${facility.facilityType?.description ?? 'No Description'}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
