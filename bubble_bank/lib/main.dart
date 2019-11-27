import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import 'package:bubble_bank/theme/style.dart';
import 'package:bubble_bank/screens/bubbleView.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

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
  List<Group> userGroups = <Group>[
    new Group("Shopping", '👕'),
    new Group("Transport", '🚂'),
    new Group("Restaurants", '🍕'),
    new Group("Groceries", "🛒"),
    new Group("Other", '🤷‍♀️'),
  ];

  List<Transaction> userTransactions;

  List<Transaction> jsonToTransactions(String data) {
    List<Transaction> transactions = List<Transaction>();
    List list = json.decode(data);
    for (Map map in list){
      Transaction t = new Transaction(map["amount"], DateTime.parse(map["date"]), map["description"], map["group"]);
      transactions.add(t);
    }
    return transactions;
  }

  List<Transaction> csvToTransactions(String data) {
    List<Transaction> transactions = List<Transaction>();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);

    DateFormat format = new DateFormat("dd/MM/yyyy");
    for (dynamic row in rowsAsListOfValues.getRange(3, rowsAsListOfValues.length-1)){
      Transaction t = new Transaction(row[3], format.parse(row[0]), row[2], null);
      transactions.add(t);
    }
    return transactions;
  }

  void readInTransactions() async {
    String data = await getFileData("assets/SCOTTFD-20191127.csv");
    userTransactions = csvToTransactions(data);
    //String data = await getFileData("assets/transactions.json");
    //userTransactions = jsonToTransactions(data);
  }

  @override
  Widget build(BuildContext context) {
    readInTransactions();
    return bubblScaffold(context, userTransactions, userGroups);
  }
}

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}