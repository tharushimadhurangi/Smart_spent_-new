import 'package:flutter/material.dart';

enum TransactionType {
  income,
  expense,
}

class TransactionCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;

  const TransactionCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  // Predefined Categories matching design
  static const List<TransactionCategory> predefinedCategories = [
    // Categories highlighted in Screen 5
    TransactionCategory(
      id: 'food',
      name: 'Food & Dining',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFF97316), // Orange
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_bus_rounded,
      color: Color(0xFF3B82F6), // Blue
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFFEC4899), // Pink
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'bills',
      name: 'Bills',
      icon: Icons.receipt_long_rounded,
      color: Color(0xFF10B981), // Teal/Green
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'salary',
      name: 'Salary',
      icon: Icons.work_rounded,
      color: Color(0xFF06B6D4), // Cyan
      type: TransactionType.income,
    ),
    TransactionCategory(
      id: 'others',
      name: 'Others',
      icon: Icons.more_horiz_rounded,
      color: Color(0xFFA855F7), // Purple
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'gift',
      name: 'Gift',
      icon: Icons.card_giftcard_rounded,
      color: Color(0xFF10B981), // Green
      type: TransactionType.income,
    ),
    TransactionCategory(
      id: 'freelance',
      name: 'Freelance',
      icon: Icons.laptop_mac_rounded,
      color: Color(0xFF8B5CF6), // Violet
      type: TransactionType.income,
    ),
    TransactionCategory(
      id: 'investments',
      name: 'Investments',
      icon: Icons.trending_up_rounded,
      color: Color(0xFF0284C7), // Sky Blue
      type: TransactionType.income,
    ),
    TransactionCategory(
      id: 'health',
      name: 'Healthcare',
      icon: Icons.medical_services_rounded,
      color: Color(0xFFEF4444), // Red
      type: TransactionType.expense,
    ),
    TransactionCategory(
      id: 'education',
      name: 'Education',
      icon: Icons.school_rounded,
      color: Color(0xFF6366F1), // Indigo
      type: TransactionType.expense,
    ),
  ];

  static List<TransactionCategory> get incomeCategories => predefinedCategories
      .where((c) => c.type == TransactionType.income)
      .toList();

  static List<TransactionCategory> get expenseCategories => predefinedCategories
      .where((c) => c.type == TransactionType.expense)
      .toList();

  static List<TransactionCategory> get allCategories => predefinedCategories;

  static TransactionCategory getById(String id,
      [TransactionType? fallbackType]) {
    final found = predefinedCategories.where((c) => c.id == id);
    if (found.isNotEmpty) return found.first;

    if (fallbackType == TransactionType.income) {
      return incomeCategories.first;
    }
    return expenseCategories.first;
  }
}
