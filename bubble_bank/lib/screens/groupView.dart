import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import '../helper.dart';
import 'settingsHelper.dart';
import '../transactionHelper.dart';
import '../moneyHelper.dart';

Scaffold groupScaffold(List<Transaction> transactions, context, Group group){
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
                  monthlySpendingString(transactions, group),
                  style: TextStyle(fontSize: 26),
                  textAlign: TextAlign.center,
                )
            ),
            Expanded(
                child: transactionsView(transactionsTilesWithCategorys(groupDuplicates(sortTransactions(transactions, "amount", true)), group), context)
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

String monthlySpendingString(List<Transaction> transactions, Group group){
  return "You spent ${formatBalance(-getBalance(transactions))} on ${group.name} in the past month.";
}


List<Transaction> groupDuplicates(List<Transaction> transactions){
  Map<String, Map<double, int>> similarTransactionsCount = new Map<String, Map<double, int>>();
  List<Transaction> groupedTransactions = new List<Transaction>();
  for (Transaction t in transactions) {
    if (!similarTransactionsCount.containsKey(t.description) || !similarTransactionsCount[t.description].containsKey(t.amount)) {
      similarTransactionsCount[t.description] = {};
      similarTransactionsCount[t.description][t.amount] = 0;
    }
    similarTransactionsCount[t.description][t.amount] += 1;
  }
  for (String des in similarTransactionsCount.keys) {
    for (double amo in similarTransactionsCount[des].keys) {
      int count = similarTransactionsCount[des][amo];
      double transactionAmount;
      String transactionDescription;
      if (count > 1) {
        transactionAmount = amo*count;
        transactionDescription = des + ' x ' + count.toString();
      } else {
        transactionAmount = amo;
        transactionDescription = des;
      }
      groupedTransactions.add(Transaction(transactionAmount, null, transactionDescription, ""));
    }
  }
  return groupedTransactions;
}