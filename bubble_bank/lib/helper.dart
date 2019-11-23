
//Helper functions for validating fields
String validatePayee(String payeeName){
  if (payeeName.isEmpty) {
    return 'Username can\'t be empty.';
  }
  return null;
}

String validateAmount(String amount){
  if (amount.isEmpty) {
    return "Amount can\'t be empty.";
  } else if (amount == "0"){
    return "Amount can\'t be zero";
  }
  return null;
}

//Helper functions for calculating moneys and formatting with currency symbols etc
double getBalance(transactions){
  var amounts = transactions.map((transaction) => transaction["amount"]);
  var totalSpending = amounts.reduce((curr, next) => curr + next);
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