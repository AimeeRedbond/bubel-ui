import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/theme/style.dart';
import 'package:bubble_bank/screens/bubbleView.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';

import 'helper.dart';

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

class BankingState extends State<Banking> {
  List<Transaction> _transactions = <Transaction>[
    new Transaction(-13.50, DateTime.parse("2019-11-24"), "Kremlin museum",
        "Entertainment"),
    new Transaction(-3.4, DateTime.parse("2019-11-23"), "Sainsbury's meal deal",
        "Groceries"),
    new Transaction(
        -14.50, DateTime.parse("2019-09-01"), "Trousers", "Shopping"),
    new Transaction(
        -5.0, DateTime.parse("2019-09-29"), "Starbucks coffee", "Restaurants"),
    new Transaction(
        -15.0, DateTime.parse("2019-10-01"), "Bus ticket", "Transport"),
    new Transaction(
        -5.0, DateTime.parse("2019-10-01"), "Train ticket", "Transport"),
    new Transaction(
        -5.0, DateTime.parse("2019-09-04"), "Train ticket", "Transport"),
    new Transaction(-15.0, DateTime.parse("2019-10-01"), "Bus ticket", "Other"),
    new Transaction(200.0, DateTime.parse("2019-11-22"), "Got a fiver", null),
  ];

  @override
  Widget build(BuildContext context) {
    return bubblScaffold(context, _transactions);
  }
}

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}