import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helper.dart';
import 'package:bubble_bank/screens/settingsView.dart';
import '../components/menuDrawer.dart';
import '../components/spendingStandardRow.dart';
import '../components/bubblWheel.dart';

Scaffold homeScreen(context, transactions, groups) {
  return Scaffold(
    drawer: menuDrawer(),
    appBar: AppBar(
      title: Center(child: Text('bubbl')),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.settings), onPressed: () {
          pushView(context, Settings(settingsStuff: SettingsStuff('Customise your bubbls', ['Set your spending groups', 'Set up your transactions timeframe', 'Use text labels instead of emojis'])));
        }),
      ],
    ),
    body: Container(
      child: Column(
        children: <Widget>[
          Expanded(child: BubblWheel(userInfo: UserInfo(transactions, groups))),
          spendingStandardRow(context, transactions)
        ],
      ),
    ),
  );
}
