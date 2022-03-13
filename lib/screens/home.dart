import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tournzone/screens/notifier.dart';
import 'package:tournzone/screens/profile/profile_page.dart';
import 'package:tournzone/screens/matches/upcoming.dart';
import 'ongoing.dart';
import 'result/completed.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = 'home';
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  int? accountBalance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  final tabs = [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Upcoming(),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: OnGoing(),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Completed(),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Notifier(),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Profile(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title:
              Text('TOURNZONE', style: TextStyle(fontWeight: FontWeight.bold)),
          
          actions: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.uid)
                  .snapshots(),
              builder: (ctx, snapshot) {
                accountBalance = snapshot.data?['amount'] ?? 0;
                if (!snapshot.hasData) {
                  return Text('0');
                }
                return TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.black,
                    ),
                    label: Text(
                      '₹ $accountBalance',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ));
              },
            )
          ],
        ),
        bottomNavigationBar: CustomNavigationBar(
          iconSize: 30.0,
          selectedColor: Colors.orange,
          strokeColor: Colors.orange,
          unSelectedColor: Colors.white,
          backgroundColor: Colors.black,
          items: [
            CustomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              title: Text(
                "Matches",
                style: TextStyle(color: Colors.white),
              ),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              title: Text(
                "Ongoing",
                style: TextStyle(color: Colors.white),
              ),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              title: Text(
                "Result",
                style: TextStyle(color: Colors.white),
              ),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.notifications_active_outlined),
              title: Text(
                "Notifier",
                style: TextStyle(color: Colors.white),
              ),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: tabs[_currentIndex]);
  }
}
