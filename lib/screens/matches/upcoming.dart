import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'match_detail.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({Key? key}) : super(key: key);

  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        setState(() {});
        return FirebaseFirestore.instance
            .collection('Matches')
            .where('matchStatus', isEqualTo: 'upComing')
            .orderBy('id', descending: false)
            .get();
      },
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Matches')
            .where('matchStatus', isEqualTo: 'upComing')
            .orderBy('id', descending: false)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.data?.docs.length == 0) {
            return Center(
              child: Text(
                'Today is Holiday',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                List jusers = snapshot.data!.docs[index]['users'];
                return Card(
                  color: Color(0xffEBF2E4),
                  elevation: 15,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 8),
                          child: Container(
                            height: 45,
                            child: Row(
                              children: [
                                Image.asset('images/bgmi.jpg'),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]['matchId'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]['matchTime'],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Column(
                                  children: [
                                    Text('PER KILL',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey)),
                                    Text(
                                        '₹ ${snapshot.data!.docs[index]['perKill']}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  children: [
                                    Text('TYPE',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey)),
                                    Text(snapshot.data!.docs[index]['type'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text('MODE',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                Text('TPP',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                Column(
                                  children: [
                                    Text('ENTRY FEE',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey)),
                                    Text(
                                        '₹ ${snapshot.data!.docs[index]['entryFee']}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  children: [
                                    Text('MAP',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey)),
                                    Text(snapshot.data!.docs[index]['map'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: LinearPercentIndicator(
                                          progressColor: Colors.blue,
                                          animation: true,
                                          percent: jusers.length /
                                              snapshot.data!.docs[index]
                                                  ['totalSlots'],
                                        ),
                                      ),
                                      Text(
                                          '${snapshot.data!.docs[index]['totalSlots'] - jusers.length} slots left'),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              ElevatedButton(
                                  onPressed: jusers.contains(currentUser?.uid)
                                      ? () {
                                          Navigator.of(context)
                                              .push(PageTransition(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  reverseDuration:
                                                      Duration(seconds: 1),
                                                  childCurrent: widget,
                                                  child: MatchDetailPage(
                                                      matchId: snapshot
                                                              .data!.docs[index]
                                                          ['matchId']),
                                                  type:
                                                      PageTransitionType.fade))
                                              .then((value) => setState(() {}));
                                        }
                                      : (snapshot.data!.docs[index]
                                                      ['totalSlots'] -
                                                  jusers.length) ==
                                              0
                                          ? null
                                          : () {
                                              Navigator.of(context)
                                                  .push(PageTransition(
                                                      duration:
                                                          Duration(seconds: 1),
                                                      reverseDuration:
                                                          Duration(seconds: 1),
                                                      childCurrent: widget,
                                                      child: MatchDetailPage(
                                                          matchId: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['matchId']),
                                                      type: PageTransitionType
                                                          .fade))
                                                  .then((value) =>
                                                      setState(() {}));
                                            },
                                  child: Text(jusers.contains(currentUser?.uid)
                                      ? 'Joined'
                                      : 'View'))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Image.asset('images/loading.gif',width: 110,),
          );
        },
      ),
    );
  }
}
