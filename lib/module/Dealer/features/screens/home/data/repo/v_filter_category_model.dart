import 'package:flutter/material.dart';

class FilterCategoryModel {
  final String title;
  final IconData icon;
  final List<String> options;

  FilterCategoryModel({
    required this.title,
    required this.icon,
    required this.options,
  });
}
