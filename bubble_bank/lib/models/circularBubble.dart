import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import '../helper.dart';
import '../screens/groupView.dart';


class CircularBubble extends StatelessWidget {
  final String title;
  final String subtitle;
  final double h;
  final double w;
  final double ratio;
  final Group group;
  final List<Transaction> transactions;
  final double font;
  final double subFont;

  CircularBubble({
    @required this.title,
    @required this.subtitle,
    @required this.h,
    @required this.w,
    @required this.ratio,
    @required this.group,
    @required this.transactions,
    @required this.font,
    @required this.subFont,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      child: Container(
        child: GestureDetector(
          onTap: () {pushView(context, groupScaffold(sortTransactions(transactions, "amount", false), context, group));},
          child: ClipOval(
            child: Container(
                color: Colors.pinkAccent,
                height: h, // height of the button
                width: w, // width of the button
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Center(child: Text(title, style: TextStyle(fontSize: font))),
                    Center(child: Text(subtitle, style: TextStyle(fontSize: subFont))),
                    Spacer(),
                  ],
                )
            ),
          ),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}