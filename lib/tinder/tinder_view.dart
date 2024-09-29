import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class CardSwiperView extends StatelessWidget {
  final List<Map<String, dynamic>> profiles = [
    {
      'name': 'Katarzyna Kowalski',
      'image': 'images/face1.jpeg',
      'interests': ['Running', 'Swimming', 'Yoga'],
    },
    {
      'name': 'Anna Nowak',
      'image': 'images/face2.jpg',
      'interests': ['Cycling', 'Gym Workouts', 'Dance Classes'],
    },
    {
      'name': 'Oliwia Wiśniewski',
      'image': 'images/face3.jpeg',
      'interests': ['Hiking', 'Martial Arts', 'Rock Climbing'],
    },
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
        child: Center(
          child: CardSwiper(
            cardsCount: profiles.length,
            cardBuilder: (BuildContext context, int index, int totalCards,
                int currentIndex) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        profiles[index]['image']!,
                        fit: BoxFit.cover,
                        height: 300,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profiles[index]['name']!,
                      style: const TextStyle(
                        color: Color.fromARGB(
                            255, 184, 70, 4), // Pomarańczowy kolor tekstu
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Kafelki z preferowanymi aktywnościami
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: profiles[index]['interests']
                            .map<Widget>((interest) => Chip(
                                  label: Text(interest),
                                  backgroundColor: const Color.fromARGB(
                                      255, 184, 70, 4), // Pomarańczowy kolor
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Przycisk z ikoną check
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: CircleBorder(), // Okrągły kształt
                          ),
                          onPressed: () {
                            // Akcja po naciśnięciu przycisku
                          },
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                        // Przycisk z ikoną krzyżyka
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: CircleBorder(), // Okrągły kształt
                          ),
                          onPressed: () {
                            // Akcja po naciśnięciu przycisku
                          },
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Przycisk "Napisz do mnie"
                        ElevatedButton(
                          onPressed: () {
                            // Akcja po naciśnięciu przycisku
                          },
                          style: ElevatedButton.styleFrom(
                            primary:
                                Colors.transparent, // Przezroczysty kolor tła
                            shadowColor: Colors.transparent, // Bez cienia
                          ),
                          child: Text(
                            "Text me",
                            style: const TextStyle(
                              color: Color.fromARGB(
                                  255, 184, 70, 4), // Pomarańczowy kolor tekstu
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Przycisk "Zorganizuj wspólną aktywność"
                        ElevatedButton(
                          onPressed: () {
                            // Akcja po naciśnięciu przycisku
                          },
                          style: ElevatedButton.styleFrom(
                            primary:
                                Colors.transparent, // Przezroczysty kolor tła
                            shadowColor: Colors.transparent, // Bez cienia
                          ),
                          child: Text(
                            "Organize an activity",
                            style: const TextStyle(
                              color: Color.fromARGB(
                                  255, 184, 70, 4), // Pomarańczowy kolor tekstu
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
