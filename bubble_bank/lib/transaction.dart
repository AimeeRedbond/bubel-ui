
class Transaction {
  DateTime date;
  String description;
  double amount;
  String group;

  Transaction(double amount, DateTime date, String description, String group) {
    this.date = date;
    this.description = description;
    this.amount = amount;
    this.group = group;
  }

  getField(String field){
    if (field == "amount"){
      return amount;
    } else if (field == "date"){
      return date;
    } else {
      return group;
    }
  }
}