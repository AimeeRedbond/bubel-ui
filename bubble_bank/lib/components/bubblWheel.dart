import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/circularDelegate.dart';
import '../moneyHelper.dart';
import '../models/circularBubble.dart';
import '../models/transaction.dart';
import '../models/group.dart';

Stack bubblWheel(transactions, groups){
  return Stack(
      children: <Widget>[
        Container(
          child: CustomMultiChildLayout(
            delegate: CircularLayoutDelegate(
              itemCount: groups.length,
              radius: 140.0,
            ),
            children:
            makeGroupWidgets(getRatios(segmentTransactionsByGroup(
                transactions, groups),
                getBalance(transactions), groups),
                transactions, groups),
          ),
        ),
        DefaultTextStyle(
          child: Container(
            child: Center(
                child: Text(formatMoneyWithoutPlus(getBalance(
                    transactions)))
            ),
          ),
          style: TextStyle(color: Colors.black, fontSize: 40.0),
        )
      ]
  );
}

List<Widget> makeGroupWidgets(List<List> ratios, List<Transaction> transactions, List<Group> groups) {
  double range = 170.0 - 60.0;
  double max = range/ratios[0][1];
  double fontRange = 50.0 - 20.0;
  double fontM = fontRange/ratios[0][1];
  double subRange = 20.0 - 10.0;
  double subM = subRange/ratios[0][1];
  List<Widget> groupWidgets = [];
  for (int i = 0; i < groups.length; i++) {
    Group group = ratios[i][0];
    double ratio = ratios[i][1];
    List<Transaction> groupTransactions = segmentTransactionsByGroup(transactions, groups)[group];
    groupWidgets.add( LayoutId(
        id: 'GROUP$i',
        child: CircularBubble(
          title: group.emoji,
          subtitle: formatMoneyWithoutPlus(-getBalance(segmentTransactionsByGroup(transactions, groups)[group])).toString(),
          ratio: ratio,
          h: 60.0 + ratio*max,
          w: 60.0 + ratio*max,
          group: group,
          transactions: groupTransactions,
          font: 20.0 + ratio*fontM,
          subFont: 10.0 + ratio*subM,
        )
    ));
  }
  return groupWidgets;
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

Map<Group, List<Transaction>> segmentTransactionsByGroup(List<Transaction> transactions, List<Group> groups){
  Map<Group, List<Transaction>> transactionsByGroup = new Map.fromIterable(groups,
      key: (item) => item,
      value: (item) => []);
  for (Group group in transactionsByGroup.keys){
    transactionsByGroup[group] = transactions.where((Transaction t) => t.amount < 0 && t.group == group.name).toList();
  }
  return transactionsByGroup;
}