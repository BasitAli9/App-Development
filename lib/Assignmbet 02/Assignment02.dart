import 'package:flutter/material.dart';

void main() {
  runApp(TravelGuideApp());
}

class TravelGuideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Guide UK',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey.shade100,
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      debugShowCheckedModeBanner: false,
      home: TravelHome(),
    );
  }
}


class TravelHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Travel Guide UK',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal.shade700,
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.home), text: "Home"),
              Tab(icon: Icon(Icons.map_rounded), text: "Destinations"),
              Tab(icon: Icon(Icons.info_outline), text: "About"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            PlacesScreen(),
            AboutScreen(),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> destinations = const [
    {
      'name': 'London',
      'image': 'assets/images/london.jpg',
      'description':
      'The capital city of England, famous for Big Ben, the London Eye, Buckingham Palace, and the River Thames.'
    },
    {
      'name': 'Edinburgh',
      'image': 'assets/images/edinburgh.jpg',
      'description':
      'The capital of Scotland, known for its stunning castle, ancient streets, and the famous Edinburgh Festival.'
    },
    {
      'name': 'Manchester',
      'image': 'assets/images/manchester.jpg',
      'description':
      'A vibrant city known for its music scene, football clubs, and industrial heritage.'
    },
    {
      'name': 'Liverpool',
      'image': 'assets/images/liverpool.jpg',
      'description':
      'The hometown of The Beatles, with rich culture, history, and a beautiful waterfront.'
    },
    {
      'name': 'Cambridge',
      'image': 'assets/images/cambridge.jpg',
      'description':
      'Home to the world-famous University of Cambridge and picturesque river punting.'
    },
    {
      'name': 'Oxford',
      'image': 'assets/images/oxford.jpg',
      'description':
      'A historic city known for its university, museums, and classic English architecture.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final place = destinations[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceDetailScreen(
                    name: place['name']!,
                    image: place['image']!,
                    description: place['description']!,
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.teal.shade50,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      child: Image.asset(
                        place['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      place['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlaceDetailScreen extends StatelessWidget {
  final String name;
  final String image;
  final String description;

  const PlaceDetailScreen({
    super.key,
    required this.name,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal.shade700,
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image, fit: BoxFit.cover, width: double.infinity),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                label: const Text("Back", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  final List<String> places = const [
    'Big Ben - London',
    'Edinburgh Castle - Edinburgh',
    'Stonehenge - Wiltshire',
    'Oxford University - Oxford',
    'Cambridge University - Cambridge',
    'Lake District - Cumbria',
    'Tower Bridge - London',
    'Roman Baths - Bath',
    'Windsor Castle - Berkshire',
    'Hadrian’s Wall - Northern England',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.place_rounded, color: Colors.amber),
            title: Text(
              places[index],
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          );
        },
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About the United Kingdom 🇬🇧',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 12),
            const Text(
              'The United Kingdom (UK) is made up of England, Scotland, Wales, and Northern Ireland. '
                  'It is known for its rich history, royal heritage, cultural diversity, and beautiful landscapes.',
              style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/london_bridge.jpg',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home_filled, color: Colors.white),
                label: const Text("Go to Home", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
