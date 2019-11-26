import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/circularDelegate.dart';
import '../helper.dart';
import 'standardView.dart';

Scaffold bubblScaffold(context, transactions) {
  return Scaffold(
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu',
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
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
      title: Center(child: Text('bubbl')),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.settings), onPressed: () {
          pushView(context, bubblViewSettingsScaffold(context));
        }),
      ],
    ),
    body: Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
                children: <Widget>[
                  Container(
                    child: CustomMultiChildLayout(
                      delegate: CircularLayoutDelegate(
                        itemCount: userGroups.length,
                        radius: 140.0,
                      ),
                      children:
                      makeGroupWidgets(getRatios(segmentTransactionsByGroup(
                          transactions, userGroups),
                          getBalance(transactions), userGroups),
                          transactions, userGroups),
                    ),
                  ),
                  DefaultTextStyle(
                    child: Container(
                      child: Center(
                          child: Text(formatBalance(getBalance(
                              transactions)))
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
                      textColor: Colors.white,
                      //`Icon` to display
                      child: Text('Spending Visuals'),
                      //`Text` to display
                      onPressed: () {},
                      padding: EdgeInsets.all(20.0),
                    )
                ),
                Expanded(
                    child: FlatButton(
                      color: buttons,
                      textColor: Colors.white,
                      child: Text('Standard View'),
                      //`Text` to display
                      onPressed: () {
                        pushView(context,
                            standardScaffold(transactions, context));
                      },
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


Scaffold bubblViewSettingsScaffold(context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: settingsList(['Set your spending groups', 'Set up your transactions timeframe']),
  ).toList();

  return Scaffold(
    appBar: AppBar(
      title: Text('Customise your bubbls'),
    ),
    body: ListView(children: divided),
  );
}
