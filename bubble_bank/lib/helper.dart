import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'models/transaction.dart';
import 'models/group.dart';

class UserInfo {
  final List<Transaction> transactions;
  final List<Group> groups;

  UserInfo(this.transactions, this.groups);
}

class GroupInfo {
  final List<Transaction> transactions;
  final Group group;

  GroupInfo(this.transactions, this.group);
}

void pushView(BuildContext context, Widget scaffold) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (BuildContext context) => scaffold),
  );
}