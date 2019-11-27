import 'package:bubble_bank/moneyHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helper.dart';
import 'settingsHelper.dart';
import '../components/menuDrawer.dart';
import '../components/spendingStandardRow.dart';
import '../components/bubblWheel.dart';
import '../models/transaction.dart';

Scaffold bubblScaffold(context, transactions, groups) {
  return Scaffold(
    drawer: menuDrawer(),
    appBar: AppBar(
      title: Center(child: Text('bubbl')),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.settings), onPressed: () {
          pushView(context, bubblViewSettingsScaffold(context));
        }),
      ],
    ),
    body: Container(
      child: Column(
        children: <Widget>[
          Expanded(child: bubblWheel(transactions.where((Transaction t) => t.amount < 0).toList(), groups, getBalance(transactions))),
          spendingStandardRow(context, transactions)
        ],
      ),
    ),
  );
}

Scaffold bubblViewSettingsScaffold(context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: settingsList(['Set your spending groups', 'Set up your transactions timeframe']),
  ).toList();

  return Scaffold(
    appBar: AppBar(
      title: Text('Customise your bubbls'),
    ),
    body: ListView(children: divided),
  );
}

