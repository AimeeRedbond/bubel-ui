import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/circularDelegate.dart';
import '../models/circularBubble.dart';
import '../models/transaction.dart';
import '../models/group.dart';
import '../helper.dart';
import 'standardView.dart';
import 'settingsHelper.dart';
import '../components/settingsDrawer.dart';

Scaffold bubblScaffold(context, transactions) {
  return Scaffold(
    drawer: menuDrawer(),
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
                      color: Colors.pink,
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


List<Widget> makeGroupWidgets(List<List> ratios, List<Transaction> transactions, List<Group> groups) {
  double range = 170.0 - 60.0;
  double max = range/ratios[0][1];
  double fontRange = 50.0 - 20.0;
  double fontM = fontRange/ratios[0][1];
  double subRange = 20.0 - 10.0;
  double subM = subRange/ratios[0][1];
  List<Widget> groupWidgets = [];
  for (int i = 0; i < groups.length; i++) {
    Group group = ratios[i][0];
    double ratio = ratios[i][1];
    List<Transaction> groupTransactions = segmentTransactionsByGroup(transactions, groups)[group];
    groupWidgets.add( LayoutId(
        id: 'GROUP$i',
        child: CircularBubble(
          title: group.emoji,
          subtitle: formatBalance(-getBalance(segmentTransactionsByGroup(transactions, groups)[group])).toString(),
          ratio: ratio,
          h: 60.0 + ratio*max,
          w: 60.0 + ratio*max,
          group: group,
          transactions: groupTransactions,
          font: 20.0 + ratio*fontM,
          subFont: 10.0 + ratio*subM,
        )
    ));
  }
  return groupWidgets;
}