import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helper.dart';
import 'settingsHelper.dart';

Scaffold standardScaffold(transactions, context){
  return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20.0)),
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
            ),
            ListTile(
                title: Text('How it all works')
            ),
            ListTile(
                title: Text('My account details')
            ),
            ListTile(
                title: Text('Manage my bank accounts')
            ),
            ListTile(
                title: Text('Suggestions for bubbl')
            ),
          ],
        ),
      ),
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
                  formatBalance(getBalance(transactions)),
                  style: balanceFont,
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
                        color: buttons,
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