import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void pushView(context, scaffold) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return scaffold;},
    ),
  );
}