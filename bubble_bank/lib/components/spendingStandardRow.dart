import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helper.dart';
import '../screens/standardView.dart';

Row spendingStandardRow(context, transactions){
  return Row(
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
                    standardScaffold(context, transactions));
              },
              padding: EdgeInsets.all(20.0),
            )
        ),
      ]
  );
}