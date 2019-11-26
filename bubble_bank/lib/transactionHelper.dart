import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'models/transaction.dart';
import 'models/group.dart';
import 'moneyHelper.dart';

Map<Group, List<Transaction>> segmentTransactionsByGroup(List<Transaction> transactions, List<Group> groups){
  Map<Group, List<Transaction>> transactionsByGroup = new Map.fromIterable(groups,
      key: (item) => item,
      value: (item) => []);
  for (Group group in transactionsByGroup.keys){
    transactionsByGroup[group] = transactions.where((Transaction t) => t.group == group.name).toList();
  }
  return transactionsByGroup;
}

List<Transaction> sortTransactions(List<Transaction> transactions, String field, bool ascending){
  if (ascending) {
    transactions.sort((t1, t2) => t1.getField(field).compareTo(t2.getField(field)));
  } else{
    transactions.sort((t1, t2) => t2.getField(field).compareTo(t1.getField(field)));
  }
  return transactions;
}

Iterable<ListTile> transactionsTiles(List<Transaction> transactions){
  return transactions.map(
        (Transaction transaction) {
      return ListTile(
        title: Text(
          transaction.description,
          style: TextStyle(fontSize: 15.0),
        ),
        subtitle: Text(
          transaction.date != null ? transaction.date.toString().split(" ")[0] : "",
          style: TextStyle(fontSize: 15.0),
        ),
        trailing: Text(
          formatMoney(transaction.amount),
          style: TextStyle(fontSize: 15.0),
        ),
      );
    },
  );
}

Iterable<ListTile> transactionsTilesWithCategorys(List<Transaction> transactions, Group group){
  List amounts = transactions.map((transaction) => transaction.amount).toList();

  double bestDiff = -1;
  int besti = 1;
  for (int i = 1; i < amounts.length; i++) {
    double diff = amounts[i] - amounts[i-1];
    if (diff > bestDiff){
      bestDiff = diff;
      besti = i;
    }
  }

  List<ListTile> tiles = transactions.map( (Transaction transaction) {
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

  tiles.insert(0, ListTile(trailing: Text(group.emoji*3, style: TextStyle(fontSize: 24))));
  tiles.insert(besti+1, ListTile(trailing:  Text(group.emoji*2, style: TextStyle(fontSize: 24))));
  if (besti+3 < tiles.length) {
    tiles.insert(besti.toInt() + 3, ListTile(
        trailing: Text(group.emoji, style: TextStyle(fontSize: 24)))
    );
  }
  return tiles;
}

ListView transactionsView(tiles, context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: tiles,
  ).toList();

  return ListView(children: divided);
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