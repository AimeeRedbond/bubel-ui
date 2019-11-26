import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bubble_bank/transaction.dart';
import 'package:bubble_bank/group.dart';


final biggerFont = const TextStyle(fontSize: 18.0);
final balanceFont = const TextStyle(fontSize: 40);
final buttons = Colors.pink;

List<Group> lol_groups = <Group>[
  new Group("Entertainment", '🎭'),
  new Group("Shopping", '👕'),
  new Group("Transport", '🚂'),
  new Group("Restaurants", '🍕'),
  new Group("Groceries", "🛒"),
  new Group("Other", '🤷‍♀️'),
];

//Helper functions for calculating moneys and formatting with currency symbols etc
double getBalance(List<Transaction> transactions){
  List<double> amounts = transactions.map((Transaction transaction) => transaction.tran_amount).toList();
  double totalSpending = amounts.reduce((double curr, double next) => curr + next);
  return totalSpending;
}

String formatMoney(double money){
  if (money < 0.0){
    return "-£" + (-money).toStringAsFixed(2);
  }
  return "+£" + money.toStringAsFixed(2);
}

String formatBalance(double money){
  if (money < 0.0){
    return "-£" + (-money).toStringAsFixed(2);
  }
  return "£" + money.toStringAsFixed(2);
}

Map<Group, List<Transaction>> segmentTransactions(List<Transaction> transactions){

  Map<Group, List<Transaction>> groups = new Map.fromIterable(lol_groups,
      key: (item) => item,
      value: (item) => []);
  for (Group group in groups.keys){
    groups[group] = transactions.where((Transaction t) => t.tran_group == group.name).toList();
  }
  return groups;
}

List<Transaction> sortTransactions(List<Transaction> transactions, String field, bool ascending){
  if (ascending) {
    transactions.sort((t1, t2) => t1.getField(field).compareTo(t2.getField(field)));
  } else{
    transactions.sort((t1, t2) => t2.getField(field).compareTo(t1.getField(field)));
  }
  return transactions;
}

Iterable<ListTile> settingsList(List<String> settings) {
  final Iterable<ListTile> tiles = settings.map(
        (String str) {
      return ListTile(
        title: Text(
          str,
          style: biggerFont,
        ),
      );
    },
  );
  return tiles;
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

Scaffold bubblSettingsScaffold(context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: settingsList(['View in chronological order', 'Set up notifications', 'Update your bubbl emoji', 'Set up bubbl colours', 'Set your spending brackets']),
  ).toList();

  return Scaffold(
    appBar: AppBar(
      title: Text('Customise your spending breakdown'),
    ),
    body: ListView(children: divided),
  );
}

Scaffold standardSettingsScaffold(context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: settingsList(['Turn on incoming/outgoing colours', 'Set up colour according to value']),
  ).toList();

  return Scaffold(
    appBar: AppBar(
      title: Text('Customise your Standard view'),
    ),
    body: ListView(children: divided),
  );
}

Iterable<ListTile> menuList(List<String> menu) {
  final Iterable<ListTile> tiles = menu.map(
        (String str) {
      return ListTile(
        title: Text(
          str,
          style: biggerFont,
        ),
      );
    },
  );
  return tiles;
}

Scaffold menuDrawerScaffold(context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: menuList(['How it all works', 'My account details', 'Manage my bank accounts', 'Suggestions for bubbl']),
  ).toList();

  return Scaffold(
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
          ),
          ListView(children: divided),
        ],
      ),
    )
  );
}

Future<bool> setId(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.setString('id', value);
}

Future<String> getId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString('id') ?? '';
}

Iterable<ListTile> transactionsTiles(List<Transaction> transactions){
  return transactions.map(
        (Transaction transaction) {
      return ListTile(
        title: Text(
          transaction.description,
          style: biggerFont,
        ),
        subtitle: Text(
          transaction.date != null ? transaction.date.toString().split(" ")[0] : "",
          style: biggerFont,
        ),
        trailing: Text(
          formatMoney(transaction.amount),
          style: biggerFont,
        ),
      );
    },
  );
}

Iterable<ListTile> transactionsTilesWithCategorys(List<Transaction> transactions, Group group){
  List amounts = transactions.map((transaction) => transaction.amount).toList();

  double bestDiff = -1;
  double besti = 1;
  for (int i = 1; i < amounts.length; i++) {
    double diff = amounts[i] - amounts[i-1];
    if (diff > bestDiff){
      bestDiff = diff;
      besti = i.toDouble();
    }
  }

  List<ListTile> tiles = transactions.map( (Transaction transaction) {
    return ListTile(
      title: Text(
        transaction.description,
        style: biggerFont,
      ),
      trailing: Text(
        formatMoney(transaction.amount),
        style: biggerFont,
      ),
    );
  },
  ).toList();

  tiles.insert(0, ListTile(trailing: Text(
      group.emoji*3, style: TextStyle(fontSize: 28))));
  tiles.insert(besti.toInt()+1, ListTile(trailing:  Text(group.emoji*2, style: TextStyle(fontSize: 28))));
  if (besti.toInt()+3 < tiles.length) {
    tiles.insert(besti.toInt() + 3, ListTile(
        trailing: Text(group.emoji, style: TextStyle(fontSize: 28)))
    );
  }
  return tiles;
}

ListView transactionsView(tiles, context){
  final List<Widget> divided = ListTile
      .divideTiles(
    context: context,
    tiles: tiles,
  ).toList();

  return ListView(children: divided);
}

List<Transaction> groupDuplicates(List<Transaction> transactions){
  Map<String, Map<double, int>> noT = new Map<String, Map<double, int>>();
  List<Transaction> groupedTransactions = new List<Transaction>();
  for (Transaction t in transactions) {
    if (noT.containsKey(t.description) && noT[t.description].containsKey(t.amount)) {
      noT[t.description][t.amount] += 1;
    } else {
      noT[t.description] = {};
      noT[t.description][t.amount] = 1;
    }
  }
  for (String des in noT.keys) {
    for (double amo in noT[des].keys) {
      if (noT[des][amo] > 1) {
        groupedTransactions.add(Transaction(amo * noT[des][amo], null, des + ' x ' + noT[des][amo].toString(), ""));
      } else {
        groupedTransactions.add(Transaction(amo, null, des, ""));
      }
    }
  }
  return groupedTransactions;
}

List<List> sortGroupRatios(Map<Group, double> groupRatios) {
  List<List> sortedRatios = groupRatios.keys.map((Group group) {return [group, groupRatios[group]];}).toList();
  sortedRatios.sort((List p1, List p2) => p1[1].compareTo(p2[1]));
  return sortedRatios;
}

List<List> getRatios(Map<Group, List<Transaction>> transaction_in_group, double total) {
  Map<Group, double> ratios = new Map.fromIterable(lol_groups,
      key: (item) => item,
      value: (item) => 0);
  for (Group group in transaction_in_group.keys) {
    for (Transaction t in transaction_in_group[group]) {
      ratios[group] += t.amount;
    }
    ratios[group] = ratios[group]/total;
  }
  return sortGroupRatios(ratios);
}

List<Widget> makeGroupWidgets(ratios, List<Transaction> transactions) {
  double range = 170.0 - 60.0;
  double max = range/ratios[0][1];
  double fontRange = 50.0 - 20.0;
  double fontM = fontRange/ratios[0][1];
  List<Widget> groupWidgets = [];
  for (int i = 0; i < lol_groups.length; i++) {
    groupWidgets.add( LayoutId(
        id: 'GROUP$i',
        child: CircularBubble(
          name: ratios[i][0].emoji,
          ratio: ratios[i][1],
          h: 60.0 + ratios[i][1]*max,
          w: 60.0 + ratios[i][1]*max,
          group: ratios[i][0],
          transactions: transactions,
          font: 20.0 + ratios[i][1]*fontM,
        )
    ));
  }
  return groupWidgets;
}

class CircularBubble extends StatelessWidget {
  final String name;
  final double h;
  final double w;
  final double ratio;
  final Group group;
  final List<Transaction> transactions;
  final double font;

  CircularBubble({
    @required this.name,
    @required this.h,
    @required this.w,
    @required this.ratio,
    @required this.group,
    @required this.transactions,
    @required this.font,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      child: Container(
        child: GestureDetector(
          onTap: () {pushView(context, groupScaffold(sortTransactions(segmentTransactions(transactions)[group], "amount", false), context, group));},
          child: ClipOval(
            child: Container(
              color: Colors.pinkAccent,
              height: h, // height of the button
              width: w, // width of the button
              child: Center(child: Text(name, style: TextStyle(fontSize: font))),
            ),
          ),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}

void pushView(context, scaffold) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return scaffold;},
    ),
  );
}

Scaffold groupScaffold(List<Transaction> transactions, context, Group group){
  return Scaffold(
      appBar: AppBar(
        title: Center( child: Text(group.group_name)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () {pushView(context, bubblSettingsScaffold(context));}),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "You spent " + formatBalance(-getBalance(transactions)) + " on " + group.group_name + " in the past month.",
              style: TextStyle(fontSize: 34),
              textAlign: TextAlign.center,
            )
          ),
          Expanded(
            child: transactionsView(transactionsTilesWithCategorys(groupDuplicates(sortTransactions(transactions, "amount", true)), group), context)
          )
        ]
      )
  );
}