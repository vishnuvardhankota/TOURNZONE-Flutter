import 'dart:io';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:introduction_screen/introduction_screen.dart';

class OnBoarding extends StatefulWidget {
  final bool isLogin;
  const OnBoarding({Key? key, required this.isLogin}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<PageViewModel> introductionPages() {
    return [
      PageViewModel(
          image: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset('images/griefing.gif'),
          ),
          title: 'Greifing Your Teammate',
          footer: Text('TOURNZONE Rules',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.red)),
          body:
              'If you kill Your teammate Your TOURNZONE Account will Suspend. Then You will Lose all Your Money.'),
      PageViewModel(
          image: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset('images/teamup.gif'),
          ),
          title: 'TeamUp with Enemies',
          footer: Text('TOURNZONE Rules',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.red)),
          body:
              'If you Make TeamUp with Enemies Your Account will Suspend. Then You will Lose all Your Money.')
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
          next: Text(
            'Next',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          skip: null,
          pages: introductionPages(),
          onDone: () {
            if (widget.isLogin == true) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Login Success'),
                        content: Text('Please Restart the App'),
                        actions: [
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                              exit(0);
                            },
                          )
                        ],
                      ));
            } else {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Accont Created Successfully'),
                        content: Text('Please Restart the App'),
                        actions: [
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                              exit(0);
                            },
                          )
                        ],
                      ));
            }
          },
          done: Container(
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Done',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          )),
    );
  }
}
