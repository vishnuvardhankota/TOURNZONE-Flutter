import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tournzone/auth/auth_screen.dart';

class Terminated extends StatelessWidget {
  static const routeName = 'terminated-page';
  const Terminated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terminated'),
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
        child: Text('Your Account is Terminated'),
      ),
    );
  }
}
