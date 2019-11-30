import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helper.dart';
import '../screens/standardView.dart';

class SpendingStandardRow extends StatelessWidget {
  final UserInfo userInfo;

  SpendingStandardRow({Key key, @required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
              child: FlatButton(
                color: Colors.black45,
                textColor: Colors.white,
                child: Text('Spending Visuals'),
                onPressed: () {},
                padding: EdgeInsets.all(20.0),
              )
          ),
          Expanded(
              child: FlatButton(
                color: Colors.pink,
                textColor: Colors.white,
                child: Text('Standard View'),
                onPressed: () {
                  pushView(context,
                      StandardView(userInfo: userInfo));
                },
                padding: EdgeInsets.all(20.0),
              )
          ),
        ]
    );
  }
}