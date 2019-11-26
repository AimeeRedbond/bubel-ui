import 'package:bubble_bank/transaction.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';

import 'helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bubbl',
      theme: ThemeData(          // Add the 3 lines from here...
        primaryColor: Colors.pink,
      ),
      home: Banking(),
    );
  }
}

class BankingState extends State<Banking> {
  List<Transaction> _transactions = <Transaction>[
    new Transaction(-13.50, DateTime.parse("2019-11-24"),"Kremlin museum","Entertainment"),
    new Transaction(-3.4, DateTime.parse("2019-11-23"), "Sainsbury's meal deal", "Groceries"),
    new Transaction(-14.50, DateTime.parse("2019-09-01"), "Trousers", "Shopping"),
    new Transaction(-5.0, DateTime.parse("2019-09-29"), "Starbucks coffee", "Restaurants"),
    new Transaction(-15.0, DateTime.parse("2019-10-01"), "Bus ticket", "Transport"),
    new Transaction(-15.0, DateTime.parse("2019-10-01"), "Bus ticket", "Other"),
    new Transaction(200.0, DateTime.parse("2019-11-22"), "Got a fiver", null),
  ];

  @override
  Widget build(BuildContext context) {
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
              ListTile(
                title: Text('How it all works')
              ),
              ListTile(
                  title: Text('My account details')
              ),
              ListTile(
                  title: Text('Manage my bank accounts')
              ),
              ListTile(
                  title: Text('Suggestions for bubbl')
              ),
            ],
          ),
        ),
      appBar: AppBar(
        title: Center( child: Text('bubbl')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () {pushView(context, bubblViewSettingsScaffold(context));}),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: CustomMultiChildLayout(
                      delegate: _CircularLayoutDelegate(
                        itemCount: 6,
                        radius: 140.0,
                      ),
                      children:
                      makeGroups(getRatios(segmentTransactions(_transactions), getBalance(_transactions)), _transactions),
                    ),
                  ),
                  DefaultTextStyle(
                      child: Container(
                        child: Center(
                          child: Text(formatBalance(getBalance(_transactions)))
                        ),
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 40.0),
                  )
                ]
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    color: Colors.black45,
                    textColor: Colors.white,//`Icon` to display
                    child: Text('Spending Visuals'), //`Text` to display
                    onPressed: () {},
                    padding: EdgeInsets.all(20.0),
                  )
                ),
                Expanded(
                  child: FlatButton(
                    color: buttons,
                    textColor: Colors.white,
                    child: Text('Standard View'), //`Text` to display
                    onPressed: () {pushView(context, standardScaffold(_transactions, context));},
                    padding: EdgeInsets.all(20.0),
                  )
                ),
              ]
            )
          ],
        ),
      ),
    );
  }

  Scaffold standardScaffold(transactions, context){
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
            ListTile(
              title: Text('How it all works')
            ),
            ListTile(
              title: Text('My account details')
            ),
            ListTile(
              title: Text('Manage my bank accounts')
            ),
            ListTile(
              title: Text('Suggestions for bubbl')
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center( child: Text('bubbl')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () {pushView(context, standardSettingsScaffold(context));}),
        ],
      ),
      body: Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                formatBalance(getBalance(_transactions)),
                style: balanceFont,
                textAlign: TextAlign.center,
              )
          ),
          Expanded(
            child: transactionsView(transactionsTiles(sortTransactions(_transactions, "date", false)), context)
          ),
          Row(
              children: <Widget>[
                Expanded(
                    child: FlatButton(
                      color: buttons,
                      textColor: Colors.white,
                      child: Text('Spending Visuals'),
                      onPressed: () {Navigator.of(context).pop();},
                      padding: EdgeInsets.all(20.0),
                    )
                ),
                Expanded(
                    child: FlatButton(
                      textColor: Colors.white,
                      child: Text('Standard View'), //`Text` to display
                      onPressed: () {},
                      padding: EdgeInsets.all(20.0),
                      color: Colors.black45,
                    )
                ),
              ]
          )
        ],
      ),
    )
    );
  }
}


class _CircularLayoutDelegate extends MultiChildLayoutDelegate {
  final int itemCount;
  final double radius;
  static const String actionButton = 'GROUP';
  Offset center;

  _CircularLayoutDelegate({
    @required this.itemCount,
    @required this.radius,
  });

  @override
  void performLayout(Size size) {
    center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < itemCount; i++) {
      final String actionButtonId = '$actionButton$i';

      if (hasChild(actionButtonId)) {
        final Size buttonSize =
        layoutChild(actionButtonId, BoxConstraints.loose(size));
        final double itemAngle = _calculateItemAngle(i);

        positionChild(
          actionButtonId,
          Offset(
            (center.dx - buttonSize.width / 2) + (radius) * cos(itemAngle),
            (center.dy - buttonSize.height / 2) +
                (radius) * sin(itemAngle),
          ),
        );
      }
    }
  }

  @override
  bool shouldRelayout(_CircularLayoutDelegate oldDelegate) =>
      itemCount != oldDelegate.itemCount ||
          radius != oldDelegate.radius ;

  static double _radiansPerDegree = pi / 180;
  final double _startAngle = -90.0 * _radiansPerDegree;
  double _itemSpacing = 360.0 / 6.0;
  double _calculateItemAngle(int index) {
    return _startAngle + index * _itemSpacing * _radiansPerDegree;
  }

}

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}