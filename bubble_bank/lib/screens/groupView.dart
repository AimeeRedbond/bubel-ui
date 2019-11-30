import 'package:bubble_bank/screens/settingsView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import '../helper.dart';
import '../transactionHelper.dart';
import '../moneyHelper.dart';
import 'dart:math';

class GroupView extends StatelessWidget {
  final GroupInfo groupInfo;

  GroupView({Key key, @required this.groupInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(groupInfo.group.name)),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings), onPressed: () {
              pushView(context, Settings(settingsStuff: SettingsStuff(
                  'Customise your spending breakdown', [
                'View in chronological order',
                'Set up notifications',
                'Update your bubbl emoji',
                'Set up bubbl colours',
                'Set your spending brackets'
              ])));
            }),
          ],
        ),
        body: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    monthlySpendingString(groupInfo.transactions, groupInfo.group),
                    style: TextStyle(fontSize: 26),
                    textAlign: TextAlign.center,
                  )
              ),
              Expanded(
                  child: transactionsView(transactionsTilesWithCategorys(
                      groupDuplicates(groupInfo.transactions), groupInfo.group), context)
              )
            ]
        )
    );
  }
}

String monthlySpendingString(List<Transaction> transactions, Group group){
  return "You spent ${formatMoneyWithoutPlus(getBalance(transactions).abs())} on ${group.name} in the past month.";
}


List<Transaction> groupDuplicates(List<Transaction> transactions){
  Map<String, Map<double, int>> similarTransactionsCount = new Map<String, Map<double, int>>();
  List<Transaction> groupedTransactions = new List<Transaction>();
  for (Transaction t in transactions) {
    if (!similarTransactionsCount.containsKey(t.description)) {
      similarTransactionsCount[t.description] = {};
    }
    if (!similarTransactionsCount[t.description].containsKey(t.amount)) {
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

  return sortTransactions(groupedTransactions, "amount", true);
}

ListView transactionsView(Iterable<Widget> tiles, context){
  return ListView.builder(
      itemCount: tiles.toList().length,
      itemBuilder: (context, index){
        return tiles.toList()[index];
      }
  );
}

Iterable<ListTile> transactionsTilesWithCategorys(List<Transaction> transactions, Group group){
  List<ListTile> tiles = transactions.map( (Transaction transaction) {
    if (transaction.description.contains(new RegExp(r'x [1-9]'))) {
      return ListTile(
        title: Text(
          transaction.description.substring(0, transaction.description.length - 4),
          style: TextStyle(fontSize: 15.0),
        ),
        subtitle: Text(transaction.description.substring(transaction.description.length - 3)),
        trailing: Text(
          formatMoney(transaction.amount),
          style: TextStyle(fontSize: 15.0),
        ),
      );
    }
    return ListTile(
      title: Text(
        transaction.description,
        style: TextStyle(fontSize: 15.0),
      ),
      trailing: Text(
        formatMoney(transaction.amount),
        style: TextStyle(fontSize: 15.0),
      ),
    );
  },
  ).toList();

  if (transactions.isNotEmpty) {
    List amounts = transactions.map((transaction) => transaction.amount).toList();

    List<double> diffs = List<double>(amounts.length);
    diffs[0] = 100000000000;
    for (int i = 1; i < amounts.length; i++) {
      double diff = amounts[i] - amounts[i - 1];
      diffs[i] = diff;
    }

    double best = diffs.reduce(max);
    int indexOfBest = diffs.indexOf(best);

    tiles.insert(indexOfBest, ListTile(
        trailing: Text(group.emoji*3, style: TextStyle(fontSize: 24))));
  
    List<double> remainder = diffs.sublist(diffs.indexOf(best)+1);
    if (remainder.isNotEmpty) {
      best = remainder.reduce(max);
      indexOfBest = diffs.indexOf(best);

      tiles.insert(indexOfBest + 1, ListTile(
          trailing: Text(group.emoji * 2, style: TextStyle(fontSize: 24))));

      List<double> secondRemainder = diffs.sublist(diffs.indexOf(best)+1);
      if (secondRemainder.isNotEmpty) {
        best = secondRemainder.reduce(max);
        indexOfBest = diffs.indexOf(best);

        tiles.insert(indexOfBest + 2, ListTile(
            trailing: Text(group.emoji, style: TextStyle(fontSize: 24))));
      }
    }
  }
  return tiles;
}