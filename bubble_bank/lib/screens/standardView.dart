import 'dart:math';

import 'package:bubble_bank/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helper.dart';
import 'package:bubble_bank/screens/settingsView.dart';
import '../components/menuDrawer.dart';
import '../moneyHelper.dart';
import '../transactionHelper.dart';

class StandardView extends StatelessWidget {
  final UserInfo userInfo;

  StandardView({Key key, @required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuDrawer(),
        appBar: AppBar(
          title: Center(child: Text('bubbl')),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  pushView(context, Settings(settingsStuff: SettingsStuff(
                      'Customise your Standard view', [
                        'Turn off incoming/outgoing colours',
                    'Set up colour according to value'
                  ])));
                }
                ),
          ],
        ),
        body: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    formatMoneyWithoutPlus(getBalance(userInfo.transactions)),
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center,
                  )
              ),
              Expanded(
                  child: transactionList(sortTransactions(userInfo.transactions, "date", false))
              ),
              SpendingStandardRowFlipped(),
            ],
          ),
    );
  }
}

Container transactionTile(transaction) {
  return Container(
    color: tileColor(transaction.amount),
    child: ListTile(
      title: Text(
        transaction.description,
        style: TextStyle(fontSize :  15),
      ),
      subtitle: Text(
        transaction?.date.toString().split(" ")[0],
        style: TextStyle(fontSize: 15),
      ),
      trailing: Text(
        formatMoney(transaction.amount),
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}


Container transactionTileScaled(transaction) {
  double fontSize = scaleAmount(20, 0.3, transaction.amount).abs();
  double tileHeight = scaleAmount(80, 0.3, transaction.amount).abs();
  return Container(
    color: tileColor(transaction.amount),
    height: tileHeight,
    child: ListTile(
      title: Text(
        transaction.description,
        style: TextStyle(fontSize :  fontSize),
      ),
      subtitle: Text(
        transaction?.date.toString().split(" ")[0],
        style: TextStyle(fontSize: fontSize),
      ),
      trailing: Text(
        formatMoney(transaction.amount),
        style: TextStyle(fontSize: fontSize),
      ),
    ),
  );
}

class SpendingStandardRowFlipped extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
              child: FlatButton(
                color: Colors.pink,
                textColor: Colors.white,
                child: Text('Spending Visuals'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.all(20.0),
              )
          ),
          Expanded(
              child: FlatButton(
                textColor: Colors.white,
                child: Text('Standard View'),
                //`Text` to display
                onPressed: () {},
                padding: EdgeInsets.all(20.0),
                color: Colors.black45,
              )
          ),
        ]
    );
  }
}

ListView transactionList(List<Transaction> transactions){
  return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index){
        return Column(children:<Widget>[
          transactionTile(transactions[index]),
          Divider(
            thickness:1,
            height:1,
            color: Colors.black,
          )]);
      }
  );
}

Color tileColor(amount) {
  if (amount < 0.0) return Colors.red[100];
  else return Colors.green[100];
}

Color tileColorScaled(amount) {
  if (amount < 0.0) return Colors.red[scaleAmount(900, 0.3, amount) ~/ 100 * 100];
  else return Colors.green[scaleAmount(900, 0.1, amount) ~/ 100 * 100];
}

double scaleAmount(double range, double scaling, double x){
  return range/(1+exp(-scaling*x.abs()));
}