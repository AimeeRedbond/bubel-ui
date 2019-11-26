
import 'package:flutter/material.dart';

class Transaction {
  DateTime date;
  String description;
  double amount;

  Transaction(DateTime date, String description, double amount) {
    this.date = date;
    this.description = description;
    this.amount = amount;
  }
}