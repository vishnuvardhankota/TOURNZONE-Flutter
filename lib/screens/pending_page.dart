import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tournzone/auth/auth_screen.dart';

class PendingPage extends StatefulWidget {
  static const routeName = 'pending-page';
  const PendingPage({Key? key}) : super(key: key);

  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(PageTransition(
                    duration: Duration(seconds: 1),
                    child: AuthScreen(),
                    type: PageTransitionType.leftToRight));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text('Your Account is Under Verification'),
      ),
    );
  }
}
