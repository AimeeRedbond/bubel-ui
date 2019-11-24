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
        primaryColor: Colors.purpleAccent,
      ),
      home: Banking(),
    );
  }
}

class BankingState extends State<Banking> {
  List<Map> _transactions = <Map>[
    { 'amount':-13.50, 'date':"2019-11-24", "description":"Kremlin museum"},
    { 'amount':-3.4, 'date':"2019-11-23", "description":"Sainsbury's meal deal"},
    { 'amount':5.0, 'date':"2019-11-22", "description":"Got a fiver"},
    { 'amount':-45.0, 'date':"2019-11-20", "description":"Microwave"},
    { 'amount':-5.0, 'date':"2019-10-04", "description":"Starbucks coffee"},
    { 'amount':-2.0, 'date':"2019-10-03", "description":"Stickers"},
    { 'amount':-3.0, 'date':"2019-10-02", "description":"Tesco meal deal"},
    { 'amount':-15.0, 'date':"2019-10-01", "description":"Bus ticket"},
    { 'amount':-5.0, 'date':"2019-09-29", "description":"Starbucks coffee"},
    { 'amount':100.0, 'date':"2019-09-28", "description":"Top up from Banana Pay"},
  ];
  final formKey = GlobalKey<FormState>();
  String payee;
  String amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bubbl: banking made bubbly'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: _pushSettings),
        ],
      ),
      body: Container(
        color: Colors.green,
        child: Column(
          children: <Widget>[
            Container(
              height: 100.0,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  DefaultTextStyle(
                    child: Container(
                      child: GestureDetector(
                        onTap: _transferPopup,
                        child: ClipOval(
                          child: Container(
                            color: Colors.lightBlueAccent,
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
                            color: Colors.lightBlueAccent,
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
              ),
            ),
            Expanded(
              child: Container(
                child: CustomMultiChildLayout(
                  delegate: _CircularLayoutDelegate(
                    itemCount: 6,
                    radius: 150.0,
                  ),
                  children: _makeGroups(_transactions),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    color: Colors.lightBlueAccent,
                    textColor: Colors.white,//`Icon` to display
                    child: Text('Spending Visuals'), //`Text` to display
                    onPressed: () {},
                    padding: EdgeInsets.all(20.0),
                  )
                ),
                Expanded(
                  child: FlatButton(
                    color: Colors.lightBlueAccent,
                    textColor: Colors.white,
                    child: Text('Standard View'), //`Text` to display
                    onPressed: _pushStandardView,
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
                      color: Colors.lightBlueAccent,
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

  Scaffold standardView(){
    final Iterable<ListTile> tiles = transactionsList(_transactions);

    var tilesList = tiles.toList();
    tilesList.insert(0, ListTile(
        title: Padding(
            padding: EdgeInsets.all(50.0),
            child: Text(
              formatBalance(getBalance(_transactions)),
              style: balanceFont,
              textAlign: TextAlign.center,
            ))
    ));
    final List<Widget> divided = ListTile
        .divideTiles(
      context: context,
      tiles: tilesList,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Spending visuals'),
      ),
      body: ListView(children: divided),
    );
  }

  void _pushStandardView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {return standardView();},
      ),
    );
  }

  List<Widget> _makeGroups(transactions) {
    List<Widget> groups = [];
    for (int i = 0; i < 6; i++) {
      groups.add( LayoutId(
        id: 'GROUP$i',
        child: CircularBubble(name: 'Food', h: 100.0, w: 100.0),
      ));
    }
    return groups;
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
      }}
  }

  // 3
  @override
  bool shouldRelayout(_CircularLayoutDelegate oldDelegate) =>
      itemCount != oldDelegate.itemCount ||
          radius != oldDelegate.radius ;

  static double _radiansPerDegree = pi / 180;
  final double _startAngle = -90.0 * _radiansPerDegree;
  double _itemSpacing = 360.0 / 5.0;
  double _calculateItemAngle(int index) {
    return _startAngle + index * _itemSpacing * _radiansPerDegree;
  }

}

class CircularBubble extends StatelessWidget {
  final String name;
  final double h;
  final double w;

  CircularBubble({
    @required this.name,
    @required this.h,
    @required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      child: Container(
        child: GestureDetector(
          onTap: () {},
          child: ClipOval(
            child: Container(
              color: Colors.amberAccent,
              height: h, // height of the button
              width: w, // width of the button
              child: Center(child: Text(name)),
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
