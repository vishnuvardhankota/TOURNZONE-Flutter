import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tournzone/auth/auth_screen.dart';
import 'package:tournzone/screens/profile/top25.dart';
import 'package:tournzone/screens/profile/wallet/wallet.dart';
import 'package:url_launcher/url_launcher.dart';

import 'my_tournments.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  String telegramUrl = "https://t.me/TOURNZONE";
  Future<void> launchtelegram(String url) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: true,
          forceWebView: false,
          headers: <String, String>{'header_key': 'header_value'});
    } else {
      print('No');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            DocumentSnapshot<Object?> data = snapshot.data!;
            String username = data['BGMI Username'];
            String bgmiId = data['BGMI ID'];
            int totalMatches = data['totalMatches'];
            int totalKills = data['totalKills'];
            int totalEarnings = data['totalEarnings'];

            return Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          height: 120,
                          width: 120,
                          child: Image.asset('images/bgmi.jpg'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UserName:-',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '      $username',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'BGMI ID:-',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '      $bgmiId',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                        ),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Matches',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Played',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '$totalMatches',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Kills',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '$totalKills',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Earned',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '$totalEarnings',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                    ]),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageTransition(
                                  duration: Duration(seconds: 1),
                                  reverseDuration: Duration(seconds: 1),
                                  child: Wallet(),
                                  childCurrent: widget,
                                  type: PageTransitionType.rightToLeft));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffEBF2E4),
                              ),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/wallet.png',
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text('My Wallet',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageTransition(
                                  duration: Duration(seconds: 1),
                                  reverseDuration: Duration(seconds: 1),
                                  child: Top25(),
                                  childCurrent: widget,
                                  type: PageTransitionType.rightToLeft));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffEBF2E4),
                              ),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/top.png',
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text('Top Earned 25 Users',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageTransition(
                                  duration: Duration(seconds: 1),
                                  reverseDuration: Duration(seconds: 1),
                                  child: MyTournments(),
                                  childCurrent: widget,
                                  type: PageTransitionType.rightToLeft));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffEBF2E4),
                              ),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/profile.png',
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text('My Tournments',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffEBF2E4),
                            ),
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/questionmark.png',
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Text('How To Join Match',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              launchtelegram(telegramUrl);
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffEBF2E4),
                              ),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/telegram.png',
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text('Customer Support',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      duration: Duration(seconds: 1),
                                      child: AuthScreen(),
                                      type: PageTransitionType.leftToRight));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffEBF2E4),
                              ),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/logout.png',
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text('LogOut',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Image.asset('images/loading.gif',width: 110,),
          );
        });
  }
}
