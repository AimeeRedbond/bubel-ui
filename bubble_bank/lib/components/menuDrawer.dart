import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuDrawer extends StatelessWidget {
  List<String> options = ['How it all works', 'My account details', 'Manage my bank accounts', 'Suggestions for bubbl'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20.0)),
            decoration: BoxDecoration(color: Colors.pink,),
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
    );
  }
}