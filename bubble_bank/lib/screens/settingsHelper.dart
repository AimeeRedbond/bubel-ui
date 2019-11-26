import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Iterable<ListTile> settingsList(List<String> settings) {
  final Iterable<ListTile> tiles = settings.map(
        (String str) {
      return ListTile(
        title: Text(
          str,
          style: TextStyle(fontSize: 18.0),
        ),
      );
    },
  );
  return tiles;
}
