import 'package:heathbridge_lao/package.dart';

class HospitalDetailPage extends StatelessWidget {
  const HospitalDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                Image.network(
                  'https://example.com/hospital_image.jpg', // Replace with actual image URL
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Mahosot Hospital',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mahosot Hospital',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'โรงพยาบาลมะโหสถ',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      Text('4.0'),
                      SizedBox(width: 8),
                      Text('(80)'),
                      SizedBox(width: 8),
                      Text('Government hospital'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('XJ67+326 โรงพยาบาลมะโหสถ, Vientiane'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 8),
                      Text('020 29 646 290'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Reviews',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 8),
                  ...List.generate(3, (index) => ReviewWidget()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.directions),
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.person, color: Colors.grey),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ผู้ใช้งาน', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('05/07/2024'),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Text('5'),
                  Icon(Icons.star, color: Colors.orange),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('รีวิวจากผู้ใช้งาน...'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () {},
              ),
              Text('2'),
              IconButton(
                icon: Icon(Icons.thumb_down),
                onPressed: () {},
              ),
              Text('0'),
            ],
          ),
        ],
      ),
    );
  }
}