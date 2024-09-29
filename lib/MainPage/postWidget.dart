import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String imagePath;
  final String username;
  final String location;
  final String description;
  final String date;

  const PostWidget({
    super.key,
    required this.imagePath,
    required this.username,
    required this.location,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, color: Colors.grey.shade700),
            ),
            title: Row(
              children: [
                Text(
                  username,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Text(
                  location,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            trailing: Icon(Icons.more_horiz),
          ),
          Container(
            width: double.infinity,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.favorite_outline),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.add_comment_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.send_outlined),
                onPressed: () {},
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.bookmark_outline),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
