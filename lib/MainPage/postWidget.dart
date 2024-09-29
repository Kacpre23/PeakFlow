import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375, // Adjust according to your layout
          height: 54, // Adjust according to your layout
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35, // Adjust according to your layout
                  height: 35, // Adjust according to your layout
                  child: Icon(Icons.person), // Replace with Image.asset if needed
                ),
              ),
              title: Text(
                'username', 
                style: TextStyle(fontSize: 13), // Adjust font size
              ),
              subtitle: Text(
                'location', 
                style: TextStyle(fontSize: 11), // Adjust font size
              ),
              trailing: Icon(Icons.more_horiz),
            ),
          ),
        ),
        Container(
          width: 375,
          height: 375,
          child: Image.asset(
            'images/beautiful-natural-image-1844362_1280.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: 375,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(width: 14), // Proper usage of children
              Row(
                children: [
                  SizedBox(width: 17),
                  const Icon(
                    Icons.favorite_outline, 
                    size: 30,
                  ),
                  SizedBox(width: 17),
                  const Icon(
                    Icons.add_comment_outlined,
                    size: 30,
                  ),
                  SizedBox(width: 17),
                  const Icon(
                    Icons.send_outlined,
                    size: 30,
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.bookmark_outline,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 19,
                  bottom: 5,
                ),
                child: Text(
                  '0',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      'username',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'kappa',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 8),
                child: Text(
                  'dateformat',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
