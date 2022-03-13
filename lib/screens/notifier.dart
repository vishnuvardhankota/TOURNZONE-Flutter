import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notifier extends StatefulWidget {
  const Notifier({Key? key}) : super(key: key);

  @override
  _NotifierState createState() => _NotifierState();
}

class _NotifierState extends State<Notifier> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Matches')
          .where('matchStatus', isEqualTo: 'OnGoing')
          .where('users', arrayContains: currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  height: 100,
                  color: Color(0xffEBF2E4),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      'If You Have Joined any Match. Room Id & Password will Displayed here Before 15 mins of match time.',
                      overflow: TextOverflow.fade,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                  )),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              List slots = snapshot.data!.docs[index]['users'];
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
                      Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${slots.length} slots',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Room ID: ${snapshot.data!.docs[index]['roomId']}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    'Room PWD: ${snapshot.data!.docs[index]['roompwd']}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
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
    );
  }
}
