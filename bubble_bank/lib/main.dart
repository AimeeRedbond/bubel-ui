import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import 'package:bubble_bank/theme/style.dart';
import 'package:bubble_bank/screens/bubbleView.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bubbl',
      theme: appTheme(),
      home: Banking(),
    );
  }
}

/// Assumes the given path is a text-file-asset.
Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

class BankingState extends State<Banking> {
  List<Transaction> userTransactions;

  List<Group> userGroups = <Group>[
    new Group("Shopping", '👕'),
    new Group("Transport", '🚂'),
    new Group("Restaurants", '🍕'),
    new Group("Groceries", "🛒"),
    new Group("Other", '🤷‍♀️'),
  ];

  void runMyFuture() async {
    String data = await getFileData("assets/transactions.json");
    List list = json.decode(data);
    userTransactions = List<Transaction>();
    for (Map map in list){
      Transaction t = new Transaction(map["amount"], DateTime.parse(map["date"]), map["description"], map["group"]);
      userTransactions.add(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    runMyFuture();
    return bubblScaffold(context, userTransactions, userGroups);
  }
}

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}