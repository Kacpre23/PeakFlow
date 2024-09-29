import 'package:flutter/material.dart';
import 'package:peakflow/join_group/join_group_view.dart';
import 'package:peakflow/personal_details/personal_details_view.dart';
import 'package:peakflow/services/auth.dart';
import 'package:peakflow/mainPage/home_page_view.dart';
import 'package:peakflow/findFriends/findfriends.dart';
import 'package:peakflow/tinder/tinder_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AuthMethods authMethods = AuthMethods();
    String userId = authMethods.getCurrentUserId();

    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.groups_2_rounded),
            icon: Icon(Icons.groups_2_outlined),
            label: 'FindFriends',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Groups',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle_rounded),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        MainPage(userId: userId),

        /// FindFriends page
        // FindFriends(userId: userId),
        CardSwiperView(),

        /// Notifications page
        ActivityCardView(),

        /// Profile page (Personal Details)
        PersonalDetails(userId: userId),
      ][currentPageIndex],
    );
  }
}
