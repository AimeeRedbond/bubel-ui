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
          IconButton(icon: Icon(Icons.settings), onPressed: () {pushView(context, settingsScaffold(context));}),
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


  Scaffold standardScaffold(transactions, context){
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Center( child: Text('bubbl')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () {pushView(context, settingsScaffold(context));}),
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

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}