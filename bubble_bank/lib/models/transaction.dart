
class Transaction {
  DateTime date;
  String description;
  double amount;
  String groupName;

  Transaction(double amount, DateTime date, String description, String groupName) {
    this.date = date;
    this.description = description;
    this.amount = amount;
    if (groupName == null) {
      this.groupName = "Other";
    } else{
      this.groupName = groupName;
    }
  }

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