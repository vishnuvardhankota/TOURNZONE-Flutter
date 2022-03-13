import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournzone/provider/match_provider.dart';

class MatchDetailPage extends StatefulWidget {
  final String matchId;
  static const routeName = 'match-detail';
  const MatchDetailPage({Key? key, required this.matchId}) : super(key: key);

  @override
  _MatchDetailPageState createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  int? accountBalance;
  int? totalSlots;
  List? users;

  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEBF2E4),
      appBar: AppBar(
        title: Text(widget.matchId),
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
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Matches')
              .doc(widget.matchId)
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text('Announcement:    ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Flexible(
                          child: Text(
                            '15 mins Before Match Time',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Matches')
                          .doc(widget.matchId)
                          .snapshots(),
                      builder: (ctx, sSnapshot) {
                        users = sSnapshot.data?['users'] ?? [];
                        totalSlots = sSnapshot.data?['totalSlots'] ?? 0;
                        int availableslots = totalSlots! - users!.length;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${totalSlots! - users!.length} slots left',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            ElevatedButton(
                              child: Text(
                                  users!.contains(currentUser?.uid)
                                      ? 'Joined'
                                      : 'Join Match',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              onPressed: availableslots == 0
                                  ? null
                                  : () async {
                                      if (users!.contains(currentUser!.uid)) {
                                        return showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: Text(
                                                      'You have already joined'),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                    )
                                                  ],
                                                ));
                                      }
                                      if (accountBalance! < entryfee) {
                                        return showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: Text('Low Balance'),
                                                  content: Text(
                                                      "Your Wallet Don't have Enough Money to Join This Match!. Please Add Money to Your Wallet"),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                    )
                                                  ],
                                                ));
                                      }
                                      setState(() {
                                        users!.add(currentUser!.uid);
                                      });
                                      setState(() {
                                        accountBalance =
                                            (accountBalance! - entryfee);
                                      });
                                      await Provider.of<MatchProvider>(context,
                                              listen: false)
                                          .joinMatche(accountBalance!, users!,
                                              widget.matchId)
                                          .then((value) => setState(() {}));
                                    },
                            ),
                          ],
                        );
                      }),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  Text('Rules & Regulations:- ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                        "  1. In case you have not join the room by match time we aren't responsible. So money would not be refund.",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(" 2. Don't share Room Id & password to anyone",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                        "  3. don't use another BGMI username which username is not matched to your TZ account. They will be kicked off from room",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                        "  4. If you found by teamUp with Enemies or killing your Teammates. Your TZ account will terminate. You will lose all your Money",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  )
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
