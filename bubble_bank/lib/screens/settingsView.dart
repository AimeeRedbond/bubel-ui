import 'package:flutter/material.dart';

class SettingsStuff {
  final String title;
  final List<String> options;

  SettingsStuff(this.title, this.options);
}

class Settings extends StatelessWidget {
  final SettingsStuff settingsStuff;

  Settings({Key key, @required this.settingsStuff}) : super(key: key);
  @override
  Widget build (BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(settingsStuff.title),
        ),
        body: ListView.builder(
            itemCount: settingsStuff.options.length,
            itemBuilder: (context, index){
              return ListTile(
                  title: Text(settingsStuff.options[index], style: TextStyle(fontSize: 18.0),)
              );
            }
        )
    );
  }
}