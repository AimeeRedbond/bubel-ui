import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import 'moneyHelper.dart';

List<Group> userGroups = <Group>[
  new Group("Entertainment", '🎭'),
  new Group("Shopping", '👕'),
  new Group("Transport", '🚂'),
  new Group("Restaurants", '🍕'),
  new Group("Groceries", "🛒"),
  new Group("Other", '🤷‍♀️'),
];

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