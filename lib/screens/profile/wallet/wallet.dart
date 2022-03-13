import 'package:flutter/material.dart';
import 'package:tournzone/screens/profile/wallet/add_money.dart';
import 'package:tournzone/screens/profile/wallet/transactions.dart';
import 'package:tournzone/screens/profile/wallet/withdraw.dart';

class Wallet extends StatelessWidget {
  const Wallet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.black,
              title: Text('TournZone',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              bottom: TabBar(
                tabs: [
                  Tab(
                      child: Text('Add Monet',
                          style: TextStyle(
                            color: Colors.white,
                          ))),
                  Tab(
                      child: Text('WithDraw',
                          style: TextStyle(
                            color: Colors.white,
                          ))),
                  Tab(
                      child: Text('Transactions',
                          style: TextStyle(
                            color: Colors.white,
                          )))
                ],
              ),
            ),
            body: TabBarView(
              children: [
                AddMoney(),
                WithDraw(),
                TransactionsPage(),
              ],
            )),
      ),
    );
  }
}
