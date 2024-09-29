import 'package:flutter/material.dart';

class ActivityCardView extends StatelessWidget {
  final List<Activity> activities = [
    Activity(
      image: 'images/run.jpg',
      description: 'Join us for a group run on Monday at 3:00 PM.',
    ),
    Activity(
      image: 'images/yoga.jpeg',
      description: 'Yoga session on Wednesday at 6:00 PM. All levels welcome!',
    ),
    Activity(
      image: 'images/run.jpg',
      description: 'Join us for a group run on Monday at 2:00 PM.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ActivityCard(activity: activity);
          },
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      color: Colors.white.withOpacity(0.8), // Lekko przezroczyste tło karty
      elevation: 4, // Dodanie cienia do karty
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Wyśrodkowanie
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              activity.image,
              fit: BoxFit.cover,
              height: 200, // Wysokość obrazu
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              activity.description,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center, // Wyśrodkowanie opisu
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center, // Wyśrodkowanie przycisków
            children: [
              TextButton(
                onPressed: () {
                  // Handle join activity
                },
                child: Text('Join Activity'),
              ),
              TextButton(
                onPressed: () {
                  // Handle reject activity
                },
                child: Text('Reject Activity'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Activity {
  final String image;
  final String description;

  Activity({required this.image, required this.description});
}

void main() {
  runApp(MaterialApp(
    home: ActivityCardView(),
  ));
}
