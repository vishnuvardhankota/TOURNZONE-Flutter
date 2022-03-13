import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Top25 extends StatelessWidget {
  static const routeName = 'results';
  const Top25({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text('Top 25 Earned Players',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5),
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Text('Rank  ',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('Usernames',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 70,
                        child: Center(
                            child: Text('Kills',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                      ),
                      Container(
                        width: 70,
                        child: Center(
                            child: Text('Earned',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('totalEarnings', descending: true)
                  .limit(25)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.data?.docs.length == 0) {
                  return Center(
                    child: Text('No Users Found'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Container(
                            padding: EdgeInsets.only(left: 5),
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      Text('${index + 1}.   ',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      Text(
                                          snapshot.data?.docs[index]
                                              ['BGMI Username'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      child: Center(
                                          child: Text(
                                              '${snapshot.data?.docs[index]['totalKills']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18))),
                                    ),
                                    Container(
                                      width: 70,
                                      child: Center(
                                          child: Text(
                                              '₹ ${snapshot.data?.docs[index]['totalEarnings']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
                return Center(child: Image.asset('images/loading.gif',width: 110,color: Colors.black,));
              },
            ),
          ],
        ),
      ),
    );
  }
}
