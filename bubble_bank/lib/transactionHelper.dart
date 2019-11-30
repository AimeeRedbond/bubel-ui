import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'models/transaction.dart';
import 'package:bubble_bank/models/transaction.dart';
import 'moneyHelper.dart';


List<Transaction> sortTransactions(List<Transaction> transactions, String field, bool ascending){
  if (ascending) {
    transactions.sort((t1, t2) => t1.getField(field).compareTo(t2.getField(field)));
  } else{
    transactions.sort((t1, t2) => t2.getField(field).compareTo(t1.getField(field)));
  }
  return transactions;
}