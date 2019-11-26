import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble_bank/models/transaction.dart';
import 'package:bubble_bank/models/group.dart';
import 'moneyHelper.dart';

List<Group> userGroups = <Group>[
  new Group("Entertainment", '🎭'),
  new Group("Shopping", '👕'),
  new Group("Transport", '🚂'),
  new Group("Restaurants", '🍕'),
  new Group("Groceries", "🛒"),
  new Group("Other", '🤷‍♀️'),
];


void pushView(context, scaffold) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return scaffold;},
    ),
  );
}