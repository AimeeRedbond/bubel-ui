import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import 'package:bubble_bank/theme/style.dart';
import 'package:bubble_bank/screens/homePage.dart';

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

class BankingState extends State<Banking> {
  List<Group> userGroups = <Group>[
    new Group("Shopping", '👕'),
    new Group("Transport", '🚂'),
    new Group("Restaurants", '🍕'),
    new Group("Groceries", "🛒"),
    new Group("Other", '🤷‍♀️'),
  ];

  Future<List<Transaction>> userTransactions;

  @override
  void initState(){
    super.initState();
    userTransactions = readInTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
      future: userTransactions, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('how are you seeing this');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
              color: Colors.pink,
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new CircularProgressIndicator(backgroundColor: Colors.white,),
                  new Text("Loading wur transactions"),
                ],
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            return homeScreen(context, snapshot.data, userGroups);
        }
        return null; // unreachable
      },
    );
  }
}

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}



/// Assumes the given path is a text-file-asset.
Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

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
    String description;
    if (["POS"].contains(row[1])){
      description = row[2].split(" , ")[1];
    } else{
      description = row[2];
    }
    Transaction t = new Transaction(row[3], format.parse(row[0]), description, null);
    transactions.add(t);
  }
  return transactions;
}

Future<List<Transaction>> readInTransactions() async {
  String data = await getFileData("assets/real_transactions/SCOTTFD-20191129.csv");
  return new Future( () {return csvToTransactions(data);});
  //String data = await getFileData("assets/transactions.json");
  //userTransactions = jsonToTransactions(data);
}
