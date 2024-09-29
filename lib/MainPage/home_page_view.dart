import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peakflow/MainPage/postWidget.dart'; // Import Firestore

class MainPage extends StatefulWidget {
  final String userId;
  String name = "";

  MainPage({super.key, required this.userId});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome back ${widget.name}!',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ),
        body: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const PostWidget();
            },
            childCount: 10, // Define how many children
          ))
        ]));
  }
}
