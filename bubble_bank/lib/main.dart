import 'package:flutter/material.dart';

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
    { 'amount':13, 'date':"2019-11-24", "description":"Unlucky buy"},
    { 'amount':3, 'date':"2019-11-23", "description":"Meal deal"},
    { 'amount':5, 'date':"2019-11-22", "description":"Cost a fiver"},
    { 'amount':45, 'date':"2019-11-20", "description":"Microwave"},
    { 'amount':5, 'date':"2019-10-01", "description":"Starbucks coffee"},
  ];
  final _biggerFont = const TextStyle(fontSize: 18.0);

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
        Center(
          child: FlatButton.icon(
            color: Colors.lightBlueAccent,
            icon: Icon(Icons.add_a_photo), //`Icon` to display
            label: Text('Add a Photo'), //`Text` to display
            onPressed: _pushStandardView,
        ),
        )
      ],
    ),
    );
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

  void _pushStandardView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _transactions.map(
                (Map transaction) {
              return ListTile(
                leading: Text(
                  transaction["description"],
                  style: _biggerFont,
                ),
                title: Text(
                  "£" + transaction["amount"].toString(),
                  style: _biggerFont,
                ),
                trailing: Text(
                  transaction["date"],
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
              title: Text('Standard view'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}
