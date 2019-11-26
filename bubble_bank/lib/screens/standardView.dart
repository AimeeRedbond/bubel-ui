import 'package:bubble_bank/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helper.dart';
import 'settingsHelper.dart';
import '../components/menuDrawer.dart';
import '../moneyHelper.dart';
import '../transactionHelper.dart';

Scaffold standardScaffold(context, List<Transaction> transactions){
  return Scaffold(
      drawer: menuDrawer(),
      appBar: AppBar(
        title: Center( child: Text('bubbl')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () {pushView(context, standardSettingsScaffold(context));}),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  formatMoneyWithoutPlus(getBalance(transactions)),
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.center,
                )
            ),
            Expanded(
                child: transactionsView(transactionsTiles(sortTransactions(transactions, "date", false)), context)
            ),
            Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                        color: Colors.pink,
                        textColor: Colors.white,
                        child: Text('Spending Visuals'),
                        onPressed: () {Navigator.of(context).pop();},
                        padding: EdgeInsets.all(20.0),
                      )
                  ),
                  Expanded(
                      child: FlatButton(
                        textColor: Colors.white,
                        child: Text('Standard View'), //`Text` to display
                        onPressed: () {},
                        padding: EdgeInsets.all(20.0),
                        color: Colors.black45,
                      )
                  ),
                ]
            )
          ],
        ),
      )
  );
}

Scaffold standardSettingsScaffold(context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: settingsList(['Turn on incoming/outgoing colours', 'Set up colour according to value']),
  ).toList();

  return Scaffold(
    appBar: AppBar(
      title: Text('Customise your Standard view'),
    ),
    body: ListView(children: divided),
  );
}

Iterable<Container> transactionsTiles(List<Transaction> transactions){
  return transactions.map(
        (Transaction transaction) {
      return Container(
        child: ListTile(
          title: Text(
            transaction.description,
            style: TextStyle(fontSize: 15.0),
          ),
          subtitle: Text(
            transaction.date != null ? transaction.date.toString().split(" ")[0] : "",
            style: TextStyle(fontSize: 15.0),
          ),
          trailing: Text(
            formatMoney(transaction.amount),
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        color: tileColor(transaction.amount),
      );
    },
  );
}

Color tileColor(amount) {
  if (amount < 0.0) {
    return Colors.red[100];
  } else {
    return Colors.green[100];
  }
}