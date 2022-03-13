import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({
    Key? key,
  }) : super(key: key);

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  int? addingBalance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  int? accountBalance;
  String? username;
  var _razorpay = Razorpay();
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update({
      'amount': (accountBalance! + addingBalance!),
    }).then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('Transactions')
          .doc(response.paymentId)
          .set({
        'id': response.paymentId,
        'paymentType': 'Added',
        'withdrawType': '',
        'phonenum': '',
        'totalAmount': addingBalance,
        'finalAmount': addingBalance,
        'time': DateTime.now().toString(),
      }).then((value) {
        Fluttertoast.showToast(msg: 'Payment success');
      });
      // Navigator.pop(context);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(msg: 'Payment fail');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    Fluttertoast.showToast(msg: 'something fail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              'YOUR WALLET',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/wallet.png',
                  height: 50,
                ),
                SizedBox(
                  width: 20,
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser!.uid)
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    accountBalance = snapshot.data?['amount'] ?? 0;
                    username = snapshot.data?['BGMI Username'];
                    if (!snapshot.hasData) {
                      return Text('0');
                    }
                    return Text(
                      '₹ $accountBalance',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 30),
                    );
                  },
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Flexible(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: amountController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Amount';
                          }
                          if (int.parse(value.trim()) < 100) {
                            return 'Amount must be ₹100 or more';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Deposit Amount',
                            border: OutlineInputBorder(),
                            hintText: 'Minimum ₹100'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          _formKey.currentState!.save();
                          setState(() {
                            addingBalance = int.parse(amountController.text);
                          });
                          var options = {
                            'key': 'rzp_test_Q0Q4EA6VMLOI8I',
                            'amount': (addingBalance! * 100),
                            'name': username,
                            'description': 'Adding Money to TOURNZONE Wallet',
                            'prefill': {'contact': '', 'email': ''}
                          };
                          _razorpay.open(options);
                          setState(() {
                            amountController.clear();
                          });
                        }
                      },
                      child: Text('Add Money'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
