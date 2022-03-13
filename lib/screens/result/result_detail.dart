import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultDetail extends StatelessWidget {
  final String matchId;
  const ResultDetail({Key? key, required this.matchId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(matchId),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Matches')
              .doc(matchId)
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> fsnapshot) {
            if (fsnapshot.hasError) {
              return Center(child: Text('Something Went Wrong'));
            }
            if (fsnapshot.connectionState == ConnectionState.done) {
              DocumentSnapshot<Object?> data = fsnapshot.data!;
              int entryfee = data['entryFee'];
              int perKill = data['perKill'];
              String type = data['type'];
              String map = data['map'];
              String matchTime = data['matchTime'];

              return ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(map == 'ERANGEL'
                        ? 'images/errangel1.jpg'
                        : map == 'SANHOK'
                            ? 'images/sanhok1.jpg'
                            : 'images/livik1.jpg'),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Match Time: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$matchTime',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Entry Fee: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('$entryfee',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Per Kill: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('$perKill',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Type: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('$type',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Map: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('$map',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Mode: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('TPP',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  Text('Results:-',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('userName',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Row(
                          children: [
                            Container(
                              width: 70,
                              child: Center(
                                  child: Text(
                                'kills',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                            ),
                            Container(
                              width: 70,
                              child: Center(
                                  child: Text('win',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Matches')
                          .doc(matchId)
                          .collection('Results')
                          .orderBy('kills', descending: true)
                          .get(),
                      builder: (context, rstSnapshot) {
                        if (rstSnapshot.connectionState ==
                            ConnectionState.done) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: rstSnapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            rstSnapshot.data?.docs[index]
                                                ['userName'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 70,
                                            child: Center(
                                                child: Text(
                                                    '${rstSnapshot.data?.docs[index]['kills']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18))),
                                          ),
                                          Container(
                                            width: 70,
                                            child: Center(
                                                child: Text(
                                                    '₹ ${rstSnapshot.data?.docs[index]['win']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18))),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                ],
              );
            }

            return Center(
              child: Image.asset('images/loading.gif',width: 110,color: Colors.black,),
            );
          }),
    );
  }
}
