import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/provider/facilities_provider.dart';
import 'package:provider/provider.dart';

final TextEditingController _searchController = TextEditingController();
List<String> _searchResults = [];
List<String> _searchHistory = [];
String _selectTypeName = 'All';
String _selectedType = 'All';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  List<String> _searchHistory = [];
  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchHistory', _searchHistory);
  }

  void _performSearch(String query) {
    setState(() {
      _searchResults = List.generate(
          10,
          (index) =>
              'Result $index for "$query" with filter "$_selectTypeName"');
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        _saveSearchHistory();
      }
    });
  }

  void _updateFilter(String filter) {
    setState(() {
      _selectTypeName = filter;
    });
  }

  void _updateType(String filter) {
    setState(() {
      _selectedType = filter;
    });
  }

  void _removeHistoryItem(String item) {
    setState(() {
      _searchHistory.remove(item);
      _saveSearchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
        // automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      extendBody: false,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5, left: 10),
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SearchBar(
                    onSearch: _performSearch,
                    searchHistory: _searchHistory,
                    onRemoveHistoryItem: _removeHistoryItem,
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(right: 10),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10.0),
              //     border: Border.all(
              //       color: ConstantColor.colorMain,
              //       width: 2.0,
              //     ),
              //   ),
              //   width: 50,
              //   height: 50,
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: const Icon(Icons.refresh),
              //   ),
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: FilterOptions(
              selectedFilter: _selectTypeName,
              onFilterChanged: _updateFilter,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Divider(),
          ),
          if (_selectTypeName == 'Pharmacy') ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterPharmacyOptions(
                selectedFilter: _selectedType,
                onFilterChanged: _updateType,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Divider(),
            ),
          ],
          if (_selectTypeName == 'Clinic') ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterTypeOptions(
                selectedFilter: _selectedType,
                onFilterChanged: _updateType,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Divider(),
            ),
          ],
          if (_selectTypeName == 'Hospital') ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterTypeOptions(
                selectedFilter: _selectedType,
                onFilterChanged: _updateType,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Divider(),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchHistoryChips(
              searchHistory: _searchHistory,
              searchController: _searchController,
              onRemoveHistoryItem: _removeHistoryItem,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final List<String> searchHistory;
  final Function(String) onRemoveHistoryItem;

  const SearchBar({
    required this.onSearch,
    required this.searchHistory,
    required this.onRemoveHistoryItem,
    super.key,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<String> _filteredSuggestions = [];

  void _updateFilteredSuggestions(String query) {
    setState(() {
      _filteredSuggestions = widget.searchHistory
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _performSearch(String query) async {
    widget.onSearch(query);
    // print(_selectedType);
    await context.read<FacilityProvider>().searchFacilities(
        _selectTypeName == query || query == "All" ? "" : query,
        _selectTypeName == "All" ? "" : _selectTypeName,
        facilityTypes:
            _selectedType == "All" ? null : [_selectedType.toLowerCase()]);

    setState(() {
      _filteredSuggestions = [];
      _searchController.clear();
    });
    Navigator.of(context).pop();
  }

  void _removeHistoryItem(String item) {
    widget.onRemoveHistoryItem(item);
  }

  void _selectHistoryItem(String item) {
    _searchController.text = item;

    _performSearch(item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              // border: const OutlineInputBorder(),
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
      ],
    );
  }
}

class FilterOptions extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  FilterOptions({
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  final List<String> _filters = [
    'All',
    'Hospital',
    'Clinic',
    'Pharmacy',
    'Ambulance'
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: _filters.map((filter) {
        return ChoiceChip(
          label: Text(filter),
          selected: selectedFilter == filter,
          onSelected: (selected) {
            onFilterChanged(filter);

            _searchController.text = filter;
          },
        );
      }).toList(),
    );
  }
}

class FilterTypeOptions extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  FilterTypeOptions({
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  final List<String> _filters = [
    'All',
    'Public',
    'Private',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: _filters.map((filter) {
        return ChoiceChip(
          label: Text(filter),
          selected: selectedFilter == filter,
          onSelected: (selected) {
            onFilterChanged(filter);
          },
        );
      }).toList(),
    );
  }
}

class FilterPharmacyOptions extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  FilterPharmacyOptions({
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  final List<String> _filters = [
    'All',
    'Traditional',
    'Private',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: _filters.map((filter) {
        return ChoiceChip(
          label: Text(filter),
          selected: selectedFilter == filter,
          onSelected: (selected) {
            onFilterChanged(filter);
          },
        );
      }).toList(),
    );
  }
}

class SearchHistoryChips extends StatefulWidget {
  final List<String> searchHistory;
  final TextEditingController searchController;
  final Function(String) onRemoveHistoryItem;

  const SearchHistoryChips({
    required this.searchHistory,
    required this.searchController,
    required this.onRemoveHistoryItem,
    super.key,
  });

  @override
  State<SearchHistoryChips> createState() => _SearchHistoryChipsState();
}

class _SearchHistoryChipsState extends State<SearchHistoryChips> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Search History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: widget.searchHistory.map((historyItem) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  label: InkWell(
                      onTap: () {
                        _searchController.text = historyItem;
                      },
                      child: Text(historyItem)),
                  onDeleted: () => widget.onRemoveHistoryItem(historyItem),
                ),
                const SizedBox(width: 4),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
