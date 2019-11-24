import 'package:flutter/material.dart';

final biggerFont = const TextStyle(fontSize: 18.0);
final balanceFont = const TextStyle(fontSize: 40);
final buttons = Colors.pink;

//Helper functions for validating fields
String validatePayee(String payeeName){
  if (payeeName.isEmpty) {
    return 'Username can\'t be empty.';
  }
  return null;
}

String validateAmount(String amount){
  if (amount.isEmpty) {
    return "Amount can\'t be empty.";
  } else if (amount == "0"){
    return "Amount can\'t be zero";
  }
  return null;
}

//Helper functions for calculating moneys and formatting with currency symbols etc
double getBalance(transactions){
  var amounts = transactions.map((transaction) => transaction["amount"]);
  var totalSpending = amounts.reduce((curr, next) => curr + next);
  return totalSpending;
}

String formatMoney(double money){
  if (money < 0.0){
    return "-£" + (-money).toStringAsFixed(2);
  }
  return "+£" + money.toStringAsFixed(2);
}

String formatBalance(double money){
  if (money < 0.0){
    return "-£" + (-money).toStringAsFixed(2);
  }
  return "£" + money.toStringAsFixed(2);
}

Map<String, List<Map>> segmentTransactions(List<Map> transactions){
  Map groups = {"Entertainment": [], "Groceries": [], "Other": [], "Transport": [], "Shopping": [], "Restaurants":[]};
  for (var group in groups.keys){
    groups[group] = transactions.where((t) => t["group"] == group).toList();
  }
  return groups;
}

List<Map> sortTransactions(List<Map> transactions, String field, bool ascending){
  if (ascending) {
    transactions.sort((t1, t2) => t1[field].compareTo(t2[field]));
  } else{
    transactions.sort((t1, t2) => t2[field].compareTo(t1[field]));
  }
  return transactions;
}

// Methods to build bespoke widgets
Iterable<ListTile> settingsList(List<String> settings) {
  final Iterable<ListTile> tiles = settings.map(
        (String str) {
          return ListTile(
            title: Text(
              str,
              style: biggerFont,
            ),
          );
          },
  );
  return tiles;
}

Scaffold settingsView(context){
  final Iterable<ListTile> tiles = settingsList(['My account details', 'Set date and time', 'Swap current default']);
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: tiles,
  ).toList();

  return Scaffold(         // Add 6 lines from here...
    appBar: AppBar(
      title: Text('Settings'),
    ),
    body: ListView(children: divided),
  );
}

Iterable<ListTile> transactionsList(List<Map> transactions){
  return sortTransactions(transactions, "date", false).map(
        (Map transaction) {
      return ListTile(
        title: Text(
          transaction["description"],
          style: biggerFont,
        ),
        subtitle: Text(
          transaction["date"].toString().split(" ")[0],
          style: biggerFont,
        ),
        trailing: Text(
          formatMoney(transaction["amount"]),
          style: biggerFont,
        ),
      );
    },
  );
}