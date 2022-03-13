import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'result_detail.dart';

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Matches')
          .where('matchStatus', isEqualTo: 'Completed')
          .orderBy('id', descending: true)
          .limit(10)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return Center(
            child: Text('No Results Found',style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              List jusers = snapshot.data!.docs[index]['users'];
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(PageTransition(
                          duration: Duration(seconds: 1),
                          reverseDuration: Duration(milliseconds: 700),
                          childCurrent: widget,
                          child: ResultDetail(
                              matchId: snapshot.data!.docs[index]['matchId']),
                          type: PageTransitionType.fade))
                      .then((value) => setState(() {}));
                },
                child: Card(
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
                        Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('${jusers.length} Players Joined'),
                        )
                      ],
                    ),
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
    );
  }
}
