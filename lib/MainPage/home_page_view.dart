import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:peakflow/MainPage/postWidget.dart';

class MainPage extends StatefulWidget {
  final String userId;
  String name = "";

  MainPage({super.key, required this.userId});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          widget.name = userDoc['name'];
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Lista obrazów, użytkowników, lokalizacji, opisów i dat
    List<Map<String, String>> posts = [
      {
        'image': 'images/beautiful-natural-image-1844362_1280.jpg',
        'username': 'John Doe',
        'location': 'New York, USA',
        'description': 'A beautiful sunset over the mountains.',
        'date': '2024-08-10',
      },
      {
        'image': 'images/bougainvillea-64413_1280.jpg',
        'username': 'Emily Smith',
        'location': 'Los Angeles, USA',
        'description': 'Bougainvillea in full bloom.',
        'date': '2024-08-15',
      },
      {
        'image': 'images/running-942110_1280.jpg',
        'username': 'Michael Brown',
        'location': 'London, UK',
        'description': 'Running in the park during sunrise.',
        'date': '2024-08-20',
      },
      {
        'image': 'images/clock-68626_1280.jpg',
        'username': 'Sophia Johnson',
        'location': 'Tokyo, Japan',
        'description': 'A vintage clock in the heart of the city.',
        'date': '2024-08-25',
      }
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Welcome back ${widget.name}!',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(200, 227, 138, 37),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(240, 255, 219, 164),
              Color.fromARGB(255, 220, 158, 88),
              Color.fromARGB(255, 227, 138, 37),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var post = posts[index];
                  return const Column(
                    children: [
                      PostWidget(),
                      SizedBox(height: 20), // Odstęp między postami
                    ],
                  );
                },
                childCount: posts.length, // Wyświetl 4 posty
              ),
            ),
          ],
        ),
      ),
    );
  }
}
