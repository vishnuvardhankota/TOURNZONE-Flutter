import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WithDraw extends StatefulWidget {
  const WithDraw({Key? key}) : super(key: key);

  @override
  _WithDrawState createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDraw> {
  static final List<String> matchStatus = ['PhonePe', 'Paytm'];
  String? selectedPaymentMethod;
  User? currentUser = FirebaseAuth.instance.currentUser;
  int? accountBalance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        isLoading
            ? Positioned(
                child: Center(
                    child: Image.asset(
                'images/loading.gif',
                width: 110,
                color: Colors.black,
              )))
            : SizedBox.shrink(),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  child: Text(
                    "If your mobile number is entered wrong it's your mistake."
                    " Your money will not refund."
                    " So please make sure that mobile number is correct or not before confirm the Withdraw.",
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
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
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text('Select Withdraw Method'),
                      value: selectedPaymentMethod,
                      items: matchStatus
                          .map((item) => DropdownMenuItem(
                                child: Text(item,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                value: item,
                              ))
                          .toList(),
                      onChanged: (selectedvalue) {
                        setState(() {
                          selectedPaymentMethod = selectedvalue as String?;
                        });
                      },
                    ),
                  ),
                ),
                if (selectedPaymentMethod != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: phoneNoController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Mobile number';
                                }
                                if (value.length != 10) {
                                  return 'Enter 10 digit Mobile number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText:
                                      (selectedPaymentMethod == 'PhonePe')
                                          ? 'PhonePe number'
                                          : 'Paytm number',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'Mobile number'),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: amountController,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Amount';
                                }
                                if (int.parse(value.trim()) < 100) {
                                  return 'Amount must be ₹100 or more';
                                }
                                if (int.parse(value.trim()) > accountBalance!) {
                                  return 'Amount is less than your wallet amount';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Withdraw Amount',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'Minimum ₹100'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        child: Text('WithDraw'),
                        onPressed: () {
                          int withdrawAmount = int.parse(amountController.text);
                          double tax = ((3 / 100) * withdrawAmount);
                          String gettingAmount =
                              (withdrawAmount - tax).toStringAsFixed(0);
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text(
                                        '₹$withdrawAmount - 3% GST =  ₹$gettingAmount'),
                                    content: Text(
                                        "your withdraw Amount  ₹$withdrawAmount. You will get ₹$gettingAmount. Please Confirm the number ${phoneNoController.text} (or) Change the number."),
                                    actions: [
                                      TextButton(
                                        child: Text('Change'),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Confirm'),
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(currentUser!.uid)
                                              .update({
                                            'amount': (accountBalance! -
                                                withdrawAmount),
                                          }).then((value) {
                                            FirebaseFirestore.instance
                                                .collection('waitingList')
                                                .doc(DateTime.now().toString())
                                                .set({
                                              'id': currentUser!.uid,
                                              'paymentType': 'Withdraw',
                                              'totalAmount': withdrawAmount,
                                              'finalAmount':
                                                  int.parse(gettingAmount),
                                              'phonenum':
                                                  phoneNoController.text,
                                              'withdrawType':
                                                  selectedPaymentMethod
                                                      .toString(),
                                              'time': DateTime.now().toString(),
                                            }).then((value) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Withdraw amount Under Proccessing');
                                            });
                                          });

                                          setState(() {
                                            selectedPaymentMethod = null;
                                            phoneNoController.clear();
                                            amountController.clear();
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.blue,
                                                  content: Text(
                                                      'Go to Transactions page... →')));
                                          Navigator.of(ctx).pop();
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                      )
                                    ],
                                  ));
                        },
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
