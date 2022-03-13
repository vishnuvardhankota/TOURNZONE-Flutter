import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User? currentUser = FirebaseAuth.instance.currentUser;

class MatchProvider extends ChangeNotifier {
  Future<void> joinMatche(
      int accountBalance, List jusers, String matchId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'amount': accountBalance}).then((value) {
        FirebaseFirestore.instance
            .collection('Matches')
            .doc(matchId)
            .update({'users': jusers}).then((value) {});
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
