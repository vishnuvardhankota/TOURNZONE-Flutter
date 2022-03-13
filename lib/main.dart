import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tournzone/screens/pending_page.dart';
import 'package:tournzone/screens/terminated.dart';
import 'auth/auth_screen.dart';
import 'provider/match_provider.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MatchProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? currentUser = FirebaseAuth.instance.currentUser?.uid;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TournZone',
      theme: ThemeData(primarySwatch: Colors.green, primaryColor: Colors.white),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data?['accountStatus'] == 'Pending') {
                  return PendingPage();
                }
                if (snapshot.data?['accountStatus'] == 'Terminated') {
                  return Terminated();
                }
                return MyHomePage();
              },
            );
          }
          return AuthScreen();
        },
      ),
      routes: {
        AuthScreen.routeName: (ctx) => AuthScreen(),
        MyHomePage.routeName: (ctx) => MyHomePage(),
        PendingPage.routeName: (ctx) => PendingPage(),
        Terminated.routeName: (ctx) => Terminated(),
      },
    );
  }
}
