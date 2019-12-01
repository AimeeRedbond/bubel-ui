
class Transaction {
  final DateTime date;
  final String description;
  final double amount;
  String groupName;

  Transaction(this.amount, this.date, this.description, this.groupName);

  getField(String field){
    if (field == "amount"){
      return amount;
    } else if (field == "date"){
      return date;
    } else {
      return groupName;
    }
  }
}