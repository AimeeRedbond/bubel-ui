import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void pushView(BuildContext context, Widget scaffold) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (BuildContext context) => scaffold),
  );
}