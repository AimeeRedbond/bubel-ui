import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helper.dart';
import 'settingsHelper.dart';
import '../components/settingsDrawer.dart';
import '../components/spendingStandardRow.dart';
import '../components/bubblWheel.dart';

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
          Expanded(child: bubblWheel(transactions, groups)),
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

