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
    body: Center(
      child: Text('Balance', style: _biggerFont,),
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
}

class Banking extends StatefulWidget {
  @override
  BankingState createState() => BankingState();
}
