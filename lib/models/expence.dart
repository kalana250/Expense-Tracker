import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'expence.g.dart'; 

// UUID generator
final uuid = Uuid().v4();

// Date formatter
final formattedDate = DateFormat.yMd();

// Annotated enum for Hive code generation
@HiveType(typeId: 2)
enum Category {
  @HiveField(0)
  food,

  @HiveField(1)
  travel,

  @HiveField(2)
  leasure,

  @HiveField(3)
  work,
}

// Category icons
final CategoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.leasure: Icons.leak_add,
  Category.travel: Icons.travel_explore,
  Category.work: Icons.work,
};

// Annotated model class
@HiveType(typeId: 1)
class ExpenceModel {
  ExpenceModel({
    required this.amount,
    required this.title,
    required this.date,
    required this.category,
  }) : id = uuid;

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Category category;

  String get getFormatedDate {
    return formattedDate.format(date);
  }
}
