import 'package:heathbridge_lao/package.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> hospitals = [
    "Mahosot Hopital, Quai Fa Ngum, Vientiane, Laos",
    "Mahosot Hopital, Quai Fa Ngum, Vientiane, Laos",
    "Mahosot Hopital, Quai Fa Ngum, Vientiane, Laos",
    "Mahosot Hopital, Quai Fa Ngum, Vientiane, Laos",
    "Mahosot Hopital, Quai Fa Ngum, Vientiane, Laos",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Hospital',
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Results for "Hospital"',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: hospitals.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text(
                      'Mahosot Hopital',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(hospitals[index]),
                    trailing: Text('Hospital'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}