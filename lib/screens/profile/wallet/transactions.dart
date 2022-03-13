import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
        // backgroundColor: Colors.grey,
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('waitingList')
                  .where('id', isEqualTo: currentUser!.uid)
                  .get(),
              builder: (context, waitSnapshots) {
                if (waitSnapshots.data?.docs.length == 0) {
                  return SizedBox.shrink();
                }
                if (waitSnapshots.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: waitSnapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      String paymentType =
                          waitSnapshots.data!.docs[index]['paymentType'];

                      int totalAmount =
                          waitSnapshots.data!.docs[index]['totalAmount'];
                      int finalAmount =
                          waitSnapshots.data!.docs[index]['finalAmount'];
                      String withdrawType =
                          waitSnapshots.data!.docs[index]['withdrawType'];
                      String phonenum =
                          waitSnapshots.data!.docs[index]['phonenum'];

                      return Card(
                        elevation: 8,
                        color: Color(0xff899FEE),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                        '$paymentType Under Process',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Text('₹$totalAmount',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20))
                                ],
                              ),
                              Text('To $withdrawType($phonenum)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('₹$totalAmount - 3% GST   =',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  Text('₹$finalAmount',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Text(
            'All Transactions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .collection('Transactions')
                  .orderBy('time', descending: true)
                  .get(),
              builder: (context, allSnapshots) {
                if (allSnapshots.data?.docs.length == 0) {
                  return Center(
                    child: Text('You Have No Transactions',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  );
                }
                if (allSnapshots.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: allSnapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      String paymentType =
                          allSnapshots.data!.docs[index]['paymentType'];
                      String time = allSnapshots.data!.docs[index]['time'];
                      int totalAmount =
                          allSnapshots.data!.docs[index]['totalAmount'];
                      int finalAmount =
                          allSnapshots.data!.docs[index]['finalAmount'];
                      String withdrawType =
                          allSnapshots.data!.docs[index]['withdrawType'];
                      String phonenum =
                          allSnapshots.data!.docs[index]['phonenum'];
                      String paymentId = allSnapshots.data!.docs[index]['id'];
                      String date = DateFormat.yMMMd()
                          .add_jm()
                          .format(DateTime.parse(time));
                      return Card(
                        elevation: 8,
                        color: Color(0xff63E474),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$paymentType',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text('PaymentId: $paymentId',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text('Date: $date',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text('₹$totalAmount',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20))
                                ],
                              ),
                              if (paymentType == 'Withdraw')
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('To $withdrawType($phonenum)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text('₹$finalAmount',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ],
                                )
                            ],
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
          ),
        ],
      ),
    ));
  }
}
