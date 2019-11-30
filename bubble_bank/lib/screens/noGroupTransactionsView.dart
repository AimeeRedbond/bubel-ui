import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/group.dart';
import '../helper.dart';
import 'package:bubble_bank/screens/settingsView.dart';

Scaffold noGroupTransactionsScaffold(context, Group group){
  return Scaffold(
      appBar: AppBar(
        title: Center( child: Text(group.name)),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                pushView(context, Settings(settingsStuff: SettingsStuff('Customise your bubbls', ['Set your spending groups', 'Set up your transactions timeframe', 'Use text labels instead of emojis'])));
          ;}),
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

String monthlySpendingString(Group group){
  return "You spent £0.00 on ${group.name} in the past month.";
}
