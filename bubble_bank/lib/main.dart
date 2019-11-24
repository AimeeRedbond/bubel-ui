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
  List<Map> _transactions = <Map>[
    { 'amount':-13.50, 'date':DateTime.parse("2019-11-24"), "description":"Kremlin museum", "group":"Entertainment"},
    { 'amount':-3.4, 'date':DateTime.parse("2019-11-23"), "description":"Sainsbury's meal deal", "group": "Groceries"},
    { 'amount':-5.0, 'date':DateTime.parse("2019-09-29"), "description":"Starbucks coffee", "group": "Restaurants"},
    { 'amount':100.0, 'date':DateTime.parse("2019-09-28"), "description":"Top up from Banana Pay"},
    { 'amount':-5.0, 'date':DateTime.parse("2019-10-04"), "description":"Starbucks coffee", "group": "Restaurants"},
    { 'amount':-2.0, 'date':DateTime.parse("2019-10-03"), "description":"Stickers", "group":"Other"},
    { 'amount':5.0, 'date':DateTime.parse("2019-11-22"), "description":"Got a fiver"},
    { 'amount':-30.0, 'date':DateTime.parse("2019-11-20"), "description":"Microwave", "group":"Other"},
    { 'amount':-15.0, 'date':DateTime.parse("2019-10-01"), "description":"Bus ticket", "group": "Transport"},
    { 'amount':-3.0, 'date':DateTime.parse("2019-10-02"), "description":"Tesco meal deal", "group": "Groceries"},
    { 'amount':-4.50, 'date':DateTime.parse("2019-10-01"), "description":"Tee-shirt", "group": "Shopping"},
  ];
  final formKey = GlobalKey<FormState>();
  String payee;
  String amount;

  Row transferButtons(){
    return Row(
        children: <Widget>[
          Spacer(),
          DefaultTextStyle(
            child: Container(
              child: GestureDetector(
                onTap: () {},
                child: ClipOval(
                  child: Container(
                    color: buttons,
                    height: 60.0, // height of the button
                    width: 60.0, // width of the button
                    child: Center(child: Icon(Icons.add),),
                  ),
                ),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          Spacer(flex: 4),
          DefaultTextStyle(
            child: Container(
              child: GestureDetector(
                onTap: _transferPopup,
                child: ClipOval(
                  child: Container(
                    color: buttons,
                    height: 60.0, // height of the button
                    width: 60.0, // width of the button
                    child: Center(child: Icon(Icons.swap_horiz)),
                  ),
                ),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Center( child: Text('bubbl')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: _pushSettings),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 100.0,
              child: transferButtons(),
            ),
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
                    onPressed: pushStandardView,
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

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
    }
  }

  Future _transferPopup(){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a payment"),
            content: Form(
              key: formKey,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: "John Doe",
                          labelText: 'To:',
                        ),
                      validator: validatePayee,
                      onSaved: (val) => payee = val,
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.account_balance_wallet),
                        hintText: "£0",
                        labelText: 'Amount',
                      ),
                      onChanged: (String s) {
                        return "£" + s;
                      },
                        validator: validateAmount,
                        onSaved: (val) => amount = val,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: buttons,
                      textColor: Colors.white,
                      child: Text("Send"),
                      onPressed: _submit,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _pushSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return settingsView(context);
        },
      ),
    );
  }

  void pushStandardView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {return lol();},
      ),
    );
  }

  void pushVisualsView() {
    Navigator.of(context).pop();
  }

  List<Widget> _makeGroups(ratios, transactions) {
    double range = 220.0 - 60.0;
    double max = range/ratios[0][1];
    double font_range = 50.0 - 20.0;
    double font_m = font_range/ratios[0][1];
    List<Widget> groups = [];
    Map<String, String> emojis = {'Restaurants':'🍕', 'Groceries':'🛒', 'Shopping':'👗', 'Transport':'🚂', 'Entertainment':'🎭', 'Other':'🤷‍♀️'};
    for (int i = 0; i < 6; i++) {
      groups.add( LayoutId(
        id: 'GROUP$i',
        child: CircularBubble(
            name: emojis[ratios[i][0]],
            ratio: ratios[i][1],
            h: 60.0 + ratios[i][1]*max,
            w: 60.0 + ratios[i][1]*max,
            group: ratios[i][0],
            t: transactions,
            font: 20.0 + ratios[i][1]*font_m,
        )
      ));
    }
    return groups;
  }

  List<List> _getRatios(groups, total) {
    Map<String, double> ratios = {'Entertainment': 0.0, 'Restaurants': 0.0, 'Groceries': 0.0, 'Shopping': 0.0, 'Transport': 0.0, 'Other': 0.0};
    for (String group in groups.keys) {
      for (var t in groups[group]) {
        ratios[group] += t['amount'];
      }
      ratios[group] = ratios[group]/total;
    }
    return sortMap(ratios);
  }

  Scaffold lol(){
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Center( child: Text('bubbl')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: _pushSettings),
        ],
      ),
      body: Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 100.0,
            child: transferButtons(),
          ),
          ListTile(
              title: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    formatBalance(getBalance(_transactions)),
                    style: balanceFont,
                    textAlign: TextAlign.center,
                  )
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

  // 3
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

class CircularBubble extends StatelessWidget {
  final String name;
  final double h;
  final double w;
  final double ratio;
  final String group;
  final List<Map> t;
  final double font;

  CircularBubble({
    @required this.name,
    @required this.h,
    @required this.w,
    @required this.ratio,
    @required this.group,
    @required this.t,
    @required this.font,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      child: Container(
        child: GestureDetector(
          onTap: () {transactionsView(transactionsTiles(sortTransactions(t, "date", false)), context);},
          child: ClipOval(
            child: Container(
              color: Colors.pinkAccent,
              height: h, // height of the button
              width: w, // width of the button
              child: Center(child: Text(name, style: TextStyle(fontSize: font))),
            ),
          ),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}