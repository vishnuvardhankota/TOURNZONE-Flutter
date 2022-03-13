import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tournzone/screens/result/result_detail.dart';

class MyTournments extends StatefulWidget {
  const MyTournments({Key? key}) : super(key: key);

  @override
  _MyTournmentsState createState() => _MyTournmentsState();
}

class _MyTournmentsState extends State<MyTournments> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text('My Tournments',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Matches')
            .where('matchStatus', isEqualTo: 'Completed')
            .where('users', arrayContains: currentUser!.uid)
            .orderBy('id', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.data?.docs.length == 0) {
            return Center(
              child: Text('No Results Found'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(PageTransition(
                            duration: Duration(seconds: 1),
                            reverseDuration: Duration(milliseconds: 700),
                            childCurrent: widget,
                            child: ResultDetail(
                                matchId: snapshot.data!.docs[index]['matchId']),
                            type: PageTransitionType.rightToLeft))
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('Matches')
                                  .doc(snapshot.data!.docs[index]['matchId'])
                                  .collection('Results')
                                  .doc(currentUser!.uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Center(
                                    child: Text('You have not Played Match'),
                                  );
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  DocumentSnapshot<Object?> data =
                                      snapshot.data!;
                                  String username = data['userName'];
                                  int kills = data['kills'];
                                  int win = data['win'];
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('YourName',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    child: Center(
                                                        child: Text(
                                                      'kills',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )),
                                                  ),
                                                  Container(
                                                    width: 70,
                                                    child: Center(
                                                        child: Text('win',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18))),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            thickness: 0.5,
                                            color: Colors.black,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(username,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15)),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    child: Center(
                                                        child: Text('$kills',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18))),
                                                  ),
                                                  Container(
                                                    width: 70,
                                                    child: Center(
                                                        child: Text('₹$win',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18))),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              }),
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
            child: Image.asset('images/loading.gif',width: 110,color: Colors.black,),
          );
        },
      ),
    );
  }
}
