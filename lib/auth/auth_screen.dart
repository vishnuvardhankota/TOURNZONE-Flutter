import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tournzone/screens/onboarding.dart';
import 'package:tournzone/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = 'authscreen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void _submitAuthForm(
      String email,
      String password,
      String username,
      String bgmiId,
      int amount,
      int totalMatches,
      int totalKills,
      int totalEarnings,
      bool isLogin,
      BuildContext ctx) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context).push(PageTransition(
            child: OnBoarding(
              isLogin: true,
            ),
            type: PageTransitionType.rightToLeft));
        setState(() {
          isLoading = false;
        });
      } else {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'UserId': userCredential.user!.uid,
          'BGMI Username': username,
          'BGMI ID': bgmiId,
          'UserEmail': email,
          'UserPassword': password,
          'amount': amount,
          'totalMatches': totalMatches,
          'totalKills': totalKills,
          'totalEarnings': totalEarnings,
          'accountStatus': 'Pending'
        });
        Navigator.of(context).push(PageTransition(
            child: OnBoarding(
              isLogin: false,
            ),
            type: PageTransitionType.rightToLeft));
        setState(() {
          isLoading = false;
        });
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(e.code),
        backgroundColor: Colors.orange,
      ));
      return;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(e.code),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/background.jpg',
                  ),
                  fit: BoxFit.cover)),
          child: isLoading ? Center(child: Image.asset('images/loading.gif',width: 150,),) : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AuthForm(_submitAuthForm),
          ),
        ),
      ),
    );
  }
}
