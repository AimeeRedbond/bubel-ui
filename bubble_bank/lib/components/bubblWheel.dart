import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/circularDelegate.dart';
import '../moneyHelper.dart';
import '../models/circularBubble.dart';
import '../models/transaction.dart';
import '../models/group.dart';
import '../helper.dart';

final double maxBubbleSize = 170;
final double minBubbleSize = 60;
final double maxFontSize = 50;
final double minFontSize = 20;
final double maxSubFontSize = 20;
final double minSubFontSize = 10;
final double wheelRadius = 140;

class BubblWheel extends StatelessWidget {
  final UserInfo userInfo;

  BubblWheel({Key key, @required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            child: CustomMultiChildLayout(
              delegate: CircularLayoutDelegate(
                itemCount: userInfo.groups.length,
                radius: wheelRadius,
              ),
              children:
              makeGroupWidgets(userInfo.transactions.where((Transaction t) => t.amount < 0 && t.date.year == DateTime.now().year && t.date.month == DateTime.now().month).toList(), userInfo.groups),
            ),
          ),
          DefaultTextStyle(
            child: Container(
              child: Center(
                  child: Text(formatMoneyWithoutPlus(getBalance(userInfo.transactions)))
              ),
            ),
            style: TextStyle(color: Colors.black, fontSize: 40.0),
          )
        ]
    );
  }
}

List<Widget> makeGroupWidgets(List<Transaction> transactions, List<Group> groups) {
  List<List> ratios = getRatios(transactions, groups);
  double max = (maxBubbleSize - minBubbleSize)/ratios[0][1];
  double fontM = (maxFontSize - minFontSize)/ratios[0][1];
  double subM = (maxSubFontSize - minSubFontSize)/ratios[0][1];
  List<Widget> groupWidgets = List<Widget>(groups.length);
  Map<Group, List<Transaction>> groupTransactions = segmentTransactionsByGroup(transactions, groups);
  for (int i = 0; i < groups.length; i++) {
    Group group = ratios[i][0];
    double ratio = ratios[i][1];
    groupWidgets[i] = ( LayoutId(
        id: 'GROUP$i',
        child: CircularBubble(
          title: group.emoji,
          subtitle: formatMoneyWithoutPlus(getBalance(groupTransactions[group]).abs()),
          h: minBubbleSize + ratio*max,
          w: minBubbleSize + ratio*max,
          group: group,
          transactions: groupTransactions[group],
          font: minFontSize + ratio*fontM,
          subFont: minSubFontSize + ratio*subM,
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

Map<Group, List<Transaction>> segmentTransactionsByGroup(List<Transaction> transactions, List<Group> groups){
  Map<Group, List<Transaction>> transactionsByGroup = new Map.fromIterable(groups,
      key: (item) => item,
      value: (item) => []);
  for (Group group in transactionsByGroup.keys){
    transactionsByGroup[group] = transactions.where((Transaction t) => t.group == group.name).toList();
  }
  return transactionsByGroup;
}

List<List> getRatios(List<Transaction> transactions, List<Group> groups) {
  double total = getBalance(transactions);
  Map<Group, List<Transaction>> groupTransactions = segmentTransactionsByGroup(transactions, groups);
  Map<Group, double> ratios = new Map.fromIterable(groups,
      key: (item) => item,
      value: (item) => 0);
  for (Group group in groupTransactions.keys) {
    ratios[group] = -getBalance(groupTransactions[group])/total;
  }
  return sortGroupRatios(ratios);
}
