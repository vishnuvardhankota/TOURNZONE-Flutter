import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
      String email,
      String password,
      String username,
      String bgmiId,
      int amount,
      int totalMatches,
      int totalKills,
      int totalEarnings,
      bool isLogin,
      BuildContext ctx) submitFn;
  AuthForm(this.submitFn);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String username = '';
  String bgmiId = '';
  String email = '';
  String password = '';
  int amount = 0;
  int totalMatches = 0;
  int totalKills = 0;
  int totalEarnings = 0;
  var isLogin = true;
  TextEditingController emailController = TextEditingController();

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();

      widget.submitFn(email, password, username, bgmiId, amount, totalMatches,
          totalKills, totalEarnings, isLogin, context);
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isForgot = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isForgot
          ? Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Center(
                        child: Text(
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    )),
                    SizedBox(
                      height: 6,
                    ),
                    Column(children: [
                      TextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Email';
                          }
                          if (!value.endsWith('@gmail.com')) {
                            return 'Please enter Email with @gmail.com';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(),
                            hintText: 'email address'),
                        onSaved: (value) {
                          email = value!.trim();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: Colors.blue,
                        ),
                        child: Text('Send Verification Email'),
                        onPressed: () async{
                          if (emailController.text.isEmpty) {
                            return;
                          }
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email: emailController.text)
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Verification Email Sent..'),
                              backgroundColor: Colors.orange,
                            ));
                            setState(() {
                              isForgot = false;
                            });
                          });
                        },
                      ),
                    ]),
                  ]),
                ),
              ),
            )
          : Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Center(
                        child: isLogin
                            ? Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                            : Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              )),
                    SizedBox(
                      height: 6,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!isLogin)
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              key: ValueKey('BGMI Username'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please copy & paste BGMI Username';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'BGMI UserName',
                                  border: OutlineInputBorder(),
                                  hintText: 'copy & paste'),
                              keyboardType: TextInputType.name,
                              onSaved: (value) {
                                username = value!.trim();
                              },
                            ),
                          SizedBox(
                            height: 6,
                          ),
                          if (!isLogin)
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              key: ValueKey('BGMI USER ID'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter BGMI or PUBG ID';
                                }
                                if (value.length < 10 && value.length > 11) {
                                  return 'USER ID must be 10 or 11 numbers long';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'BGMI USER ID',
                                  border: OutlineInputBorder(),
                                  hintText: '521114...'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                bgmiId = value!.trim();
                              },
                            ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            key: ValueKey('email'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Email';
                              }
                              if (!value.endsWith('@gmail.com')) {
                                return 'Please enter Email with @gmail.com';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'Email Address',
                                border: OutlineInputBorder(),
                                hintText: 'email address'),
                            onSaved: (value) {
                              email = value!.trim();
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.go,
                            key: ValueKey('password'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Password';
                              }
                              if (value.length < 8) {
                                return 'Password length must be 8';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                                hintText: 'password'),
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              password = value!.trim();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (isLogin)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isForgot = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              primary: isLogin ? Colors.red : Colors.blue,
                            ),
                            onPressed: _submit,
                            child: Text(isLogin ? 'LogIn' : 'Create Account'),
                          ),
                          // ignore: deprecated_member_use
                          TextButton(
                            child: Text(
                              isLogin
                                  ? 'Create New Account'
                                  : 'Already hane an account? sign in',
                              style: TextStyle(
                                  color: isLogin ? Colors.red : Colors.blue),
                            ),
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
    );
  }
}
