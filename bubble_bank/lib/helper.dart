import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';


final biggerFont = const TextStyle(fontSize: 18.0);
final balanceFont = const TextStyle(fontSize: 40);
final buttons = Colors.pink;

List<Group> userGroups = <Group>[
  new Group("Entertainment", '🎭'),
  new Group("Shopping", '👕'),
  new Group("Transport", '🚂'),
  new Group("Restaurants", '🍕'),
  new Group("Groceries", "🛒"),
  new Group("Other", '🤷‍♀️'),
];

//Helper functions for calculating moneys and formatting with currency symbols etc
double getBalance(List<Transaction> transactions){
  List<double> amounts = transactions.map((Transaction transaction) => transaction.amount).toList();
  double totalSpending = amounts.reduce((double curr, double next) => curr + next);
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


Iterable<ListTile> menuList(List<String> menu) {
  final Iterable<ListTile> tiles = menu.map(
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

Scaffold menuDrawerScaffold(context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: menuList(['How it all works', 'My account details', 'Manage my bank accounts', 'Suggestions for bubbl']),
  ).toList();

  return Scaffold(
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
          ),
          ListView(children: divided),
        ],
      ),
    )
  );
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

List<List> sortGroupRatios(Map<Group, double> groupRatios) {
  List<List> sortedRatios = groupRatios.keys.map((Group group) {return [group, groupRatios[group]];}).toList();
  sortedRatios.sort((List p1, List p2) => p1[1].compareTo(p2[1]));
  return sortedRatios;
}

List<List> getRatios(Map<Group, List<Transaction>> groupTransactions, double total, groups) {
  Map<Group, double> ratios = new Map.fromIterable(groups,
      key: (item) => item,
      value: (item) => 0);
  for (Group group in groupTransactions.keys) {
    ratios[group] = getBalance(groupTransactions[group])/total;
  }
  return sortGroupRatios(ratios);
}

void pushView(context, scaffold) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return scaffold;},
    ),
  );
}

String monthlySpendingString(List<Transaction> transactions, Group group){
  return "You spent ${formatBalance(-getBalance(transactions))} on ${group.name} in the past month.";
}