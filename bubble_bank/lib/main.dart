import 'package:flutter/material.dart';

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
  final _settings = <String>['My account details', 'Set date and time', 'Swap current default'];
  var _transactions = <Map>[
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
  var _groups = <Widget>[
    LayoutId(
      id: 'BUTTON0',
      child: Text('Food'),
    ),
    LayoutId(
      id: 'BUTTON1',
      child: Text('Food'),
    ),
    LayoutId(
      id: 'BUTTON2',
      child: Text('Food'),
    ),
    LayoutId(
      id: 'BUTTON3',
      child: Text('Food'),
    ),
    LayoutId(
      id: 'BUTTON4',
      child: Text('Food'),
    ),
    LayoutId(
      id: 'BUTTON5',
      child: Text('Food'),
    ),
  ];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _balanceFont = const TextStyle(fontSize: 40);
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
      body: Column(
        children: <Widget>[
          Row(
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
      MaterialPageRoute<void>(   // Add 20 lines from here...
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _settings.map(
                (String str) {
              return ListTile(
                title: Text(
                  str,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(         // Add 6 lines from here...
            appBar: AppBar(
              title: Text('Settings'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Iterable<ListTile> transactionsList(List<Map> transactions){
    return transactions.map(
          (Map transaction) {
        return ListTile(
          title: Text(
            transaction["description"],
            style: _biggerFont,
          ),
          subtitle: Text(
            transaction["date"],
            style: _biggerFont,
          ),
          trailing: Text(
            formatMoney(transaction["amount"]),
            style: _biggerFont,
          ),
        );
      },
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
              style: _balanceFont,
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
}

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}
