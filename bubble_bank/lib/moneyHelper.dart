import 'models/transaction.dart';

//Helper functions for calculating moneys and formatting with currency symbols etc
double getBalance(List<Transaction> transactions){
  print(transactions);
  if (transactions.length > 0) {
    List<double> amounts = transactions.map((
        Transaction transaction) => transaction.amount).toList();
    double totalSpending = amounts.reduce((double curr, double next) =>
    curr + next);
    return totalSpending;
  }
  return 0;
}

String formatMoney(double money){
  if (money < 0.0){
    return "-£ ${(-money).toStringAsFixed(2)}";
  }
  return "+£ ${money.toStringAsFixed(2)}";
}

String formatMoneyWithoutPlus(double money){
  if (money < 0.0){
    return "-£" + (-money).toStringAsFixed(2);
  }
  return "£" + money.toStringAsFixed(2);
}