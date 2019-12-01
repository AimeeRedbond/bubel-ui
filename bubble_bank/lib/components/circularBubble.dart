import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import '../helper.dart';
import '../screens/groupView.dart';
import '../transactionHelper.dart';
import '../screens/noGroupTransactionsView.dart';

class CircularBubble extends StatelessWidget {
  final String title;
  final String subtitle;
  final double h;
  final double w;
  final Group group;
  final List<Transaction> transactions;
  final double font;
  final double subFont;

  CircularBubble({
    @required this.title,
    @required this.subtitle,
    @required this.h,
    @required this.w,
    @required this.group,
    @required this.transactions,
    @required this.font,
    @required this.subFont,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.white, fontSize: font),
      child: Container(
        child: GestureDetector(
          onTap: () {
            if (transactions.isEmpty) {pushView(context, NoGroupTransactionsView(group:group));}
            else {pushView(context, GroupView(groupInfo:GroupInfo(sortTransactions(transactions, "amount", false), group)));}
            },
          child: ClipOval(
            child: Container(
                color: Colors.pinkAccent,
                height: h, // height of the button
                width: w, // width of the button
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(title),
                    Text(subtitle, style: TextStyle(fontSize: subFont)),
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}