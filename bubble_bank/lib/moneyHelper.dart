import 'models/transaction.dart';

//Helper functions for calculating moneys and formatting with currency symbols etc
double getBalance(List<Transaction> transactions){
  List<double> amounts = transactions.map((Transaction transaction) => transaction.amount).toList();
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