import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import '../helper.dart';
import 'settingsHelper.dart';
import '../transactionHelper.dart';
import '../moneyHelper.dart';
import 'dart:math';

Scaffold noGroupTransactionsScaffold(context, Group group){
  return Scaffold(
      appBar: AppBar(
        title: Center( child: Text(group.name)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () {pushView(context, bubblSettingsScaffold(context));}),
        ],
      ),
      body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  monthlySpendingString(group),
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

Scaffold bubblSettingsScaffold(context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: settingsList(['View in chronological order', 'Set up notifications', 'Update your bubbl emoji', 'Set up bubbl colours', 'Set your spending brackets']),
  ).toList();

  return Scaffold(
    appBar: AppBar(
      title: Text('Customise your spending breakdown'),
    ),
    body: ListView(children: divided),
  );
}

String monthlySpendingString(Group group){
  return "You spent £0.00 on ${group.name} in the past month.";
}
