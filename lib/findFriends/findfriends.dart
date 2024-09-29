import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class FindFriends extends StatefulWidget {
  final String userId;
  String name = "";

  FindFriends({super.key, required this.userId});

  @override
  State<FindFriends> createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {
  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // Definicja metody _fetchUserDetails do pobrania danych użytkownika
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Find Friends: ${widget.name}'),
      ),
      body: Center(
        child: Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Find friends content here.',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
