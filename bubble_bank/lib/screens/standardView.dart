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
        drawer: menuDrawer(),
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
                  ;
                }),
          ],
        ),
        body: Container(
          child: Column(
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
                  child: transactionsView(transactionsTiles(
                      sortTransactions(userInfo.transactions, "date", false)),
                      context)
              ),
              Row(
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
              )
            ],
          ),
        )
    );
  }

  Iterable<Container> transactionsTiles(List<Transaction> transactions) {
    return transactions.map(
          (Transaction transaction) {
        return Container(
          child: ListTile(
            title: Text(
              transaction.description,
              style: TextStyle(fontSize: 15.0),
            ),
            subtitle: Text(
              transaction?.date.toString().split(" ")[0],
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
}

Color tileColor(amount) {
  if (amount < 0.0) {
    return Colors.red[100];
  } else {
    return Colors.green[100];
  }
}