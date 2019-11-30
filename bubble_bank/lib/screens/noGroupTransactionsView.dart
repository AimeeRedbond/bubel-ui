import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/group.dart';
import '../helper.dart';
import 'package:bubble_bank/screens/settingsView.dart';

class NoGroupTransactionsView extends StatelessWidget {
  final GroupAndTransactions groupAndTransactions;

  NoGroupTransactionsView({Key key, @required this.groupAndTransactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(groupAndTransactions.group.name)),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  pushView(context, Settings(settingsStuff: SettingsStuff(
                      'Customise your spending breakdown', [
                    'View in chronological order',
                    'Set up notifications',
                    'Update your bubbl emoji',
                    'Set up bubbl colours',
                    'Set your spending brackets'
                  ])));
                  ;
                }),
          ],
        ),
        body: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    monthlySpendingString(groupAndTransactions.group),
                    style: TextStyle(fontSize: 26),
                    textAlign: TextAlign.center,
                  )
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "🙌",
                    style: TextStyle(fontSize: 200),
                    textAlign: TextAlign.center,
                  )
              )
            ]
        )
    );
  }
}

String monthlySpendingString(Group group){
  return "You spent £0.00 on ${group.name} in the past month.";
}
