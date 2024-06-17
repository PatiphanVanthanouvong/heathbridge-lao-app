import 'package:flutter/material.dart';
import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/provider/facilities_provider.dart';
import 'package:heathbridge_lao/src/screens/detail/fac_detail.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ListSearch extends StatefulWidget {
  const ListSearch({super.key});

  @override
  _ListSearchState createState() => _ListSearchState();
}

class _ListSearchState extends State<ListSearch>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  String? _selectedItem1;
  String? _selectedItem2;

  final List<String> _dropdownItems1 = ['Item 1', 'Item 2', 'Item 3'];
  final List<String> _dropdownItems2 = ['Option A', 'Option B', 'Option C'];

  @override
  void initState() {
    super.initState();

    // Fetch the facilities data when the widget is initialized
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<FacilityProvider>().getFacInfo();
    // });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity, // Extend width to full
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20.0)),
              border: Border.all(
                color: ConstantColor.colorMain,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: _selectedItem1,
                  hint: const Text('Select Item 1'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem1 = newValue;
                    });
                  },
                  items: _dropdownItems1
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),
                DropdownButton<String>(
                  value: _selectedItem2,
                  hint: const Text('Select Item 2'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem2 = newValue;
                    });
                  },
                  items: _dropdownItems2
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performSearch(String query) {
    // Implement your search logic here
    print('Searching for: $query');
  }

  void _updateFilteredSuggestions(String query) {
    // Implement your suggestions logic here
    print('Filtering suggestions for: $query');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Adjust the height as needed
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
                onPressed: _showBottomSheet,
                icon: const Icon(Icons.menu),
              ),
            ),
          ],
          title: InkWell(
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
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _performSearch(_searchController.text);
                    },
                  ),
                ),
                onChanged: _updateFilteredSuggestions,
                onSubmitted: _performSearch,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<FacilityProvider>(
                builder: (context, provider, child) {
                  // if (provider.isGettingFacInfo) {
                  //   return _buildLoadingSkeleton();
                  // }

                  if (provider.facData.isEmpty) {
                    return const Center(
                      child: Text('No facilities found'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.facData.length,
                    itemBuilder: (context, index) {
                      final facility = provider.facData[index];
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<FacilityProvider>()
                              .getDetailEach(facId: facility.facId!);
                          showBottomSheet(
                            elevation: 4,
                            context: context,
                            builder: (ctx) => FacDetail(facId: facility.facId!),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(
                              color: ConstantColor.colorMain,
                              width: 1.0,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                height: 90,
                                width: 60,
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
                                        fit: BoxFit.cover,
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
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            title: Text(
                              facility.name ?? 'No Name',
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${facility.facilityType?.type} ${facility.facilityType?.nameEn} ", // Assuming facilityTye has a nameLa field
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Text(
                                    overflow: TextOverflow.ellipsis,
                                    '${facility.village},  ${facility.district},  ${facility.province}.'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(
                color: ConstantColor.colorMain,
                width: 1.0,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 90,
                  width: 60,
                  color: Colors.white,
                ),
              ),
              title: Container(
                height: 20.0,
                color: Colors.white,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  Container(
                    height: 20.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 20.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
