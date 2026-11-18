import 'package:cloud_firestore/cloud_firestore.dart';
import 'category_model.dart';

class TransactionItem {
  final String id;
  final String userId;
  final String title;
  final String description;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final DateTime date;
  final String paymentMethod;
  final String? notes;
  final DateTime createdAt;

  TransactionItem({
    required this.id,
    this.userId = 'default_user',
    required this.title,
    String? description,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.paymentMethod = 'Bank Account',
    this.notes,
    DateTime? createdAt,
  })  : description = description ?? title,
        createdAt = createdAt ?? DateTime.now();

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  TransactionCategory get category =>
      TransactionCategory.getById(categoryId, type);

  // Formatted string matching design: "LKR 125,450.00" or "+ LKR 50,000" / "- LKR 1,200"
  static String formatCurrency(
    double val, {
    bool showSign = false,
    bool isIncome = false,
    bool showDecimals = false,
    String currency = 'LKR',
  }) {
    final isNegative = val < 0;
    final absVal = val.abs();

    final parts = (showDecimals ? absVal.toStringAsFixed(2) : absVal.round().toString()).split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    final buffer = StringBuffer();
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      buffer.write(integerPart[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }
    final formattedInt = buffer.toString().split('').reversed.join('');
    final fullNumber = decimalPart.isNotEmpty ? '$formattedInt.$decimalPart' : formattedInt;

    if (showSign) {
      if (isIncome) {
        return '+ $currency $fullNumber';
      } else {
        return '- $currency $fullNumber';
      }
    }

    if (isNegative) {
      return '- $currency $fullNumber';
    }
    return '$currency $fullNumber';
  }

  String get formattedAmount {
    return formatCurrency(amount, showSign: true, isIncome: isIncome);
  }

  String get formattedDisplayAmount {
    return formatCurrency(amount, showSign: false, showDecimals: true);
  }

  // Matches "Nov 05, 2026" from screenshot
  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthStr = months[date.month - 1];
    final dayStr = date.day.toString().padLeft(2, '0');
    return '$monthStr $dayStr, ${date.year}';
  }

  String get formattedTime {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final standardHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${standardHour.toString().padLeft(2, '0')}:$minute $period';
  }

  String get fullDateSubtitle {
    return '$formattedDate • ${isIncome ? "Income" : "Expense"}';
  }

  TransactionItem copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    double? amount,
    TransactionType? type,
    String? categoryId,
    DateTime? date,
    String? paymentMethod,
    String? notes,
    DateTime? createdAt,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // SharedPreferences JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    final desc = (json['description'] as String?) ?? (json['title'] as String?) ?? '';
    return TransactionItem(
      id: json['id'] as String,
      userId: (json['userId'] as String?) ?? 'default_user',
      title: (json['title'] as String?) ?? desc,
      description: desc,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      categoryId: json['categoryId'] as String,
      date: DateTime.parse(json['date'] as String),
      paymentMethod: (json['paymentMethod'] as String?) ?? 'Bank Account',
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  // Firestore Document serialization
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'category': category.name,
      'categoryId': categoryId,
      'description': description.isNotEmpty ? description : title,
      'title': title,
      'date': Timestamp.fromDate(date),
      'type': type == TransactionType.income ? 'income' : 'expense',
      'paymentMethod': paymentMethod,
      'notes': notes ?? '',
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TransactionItem.fromFirestore(Map<String, dynamic> data, String docId) {
    DateTime parsedDate;
    if (data['date'] is Timestamp) {
      parsedDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      parsedDate = DateTime.tryParse(data['date'] as String) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    DateTime parsedCreatedAt;
    if (data['createdAt'] is Timestamp) {
      parsedCreatedAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is String) {
      parsedCreatedAt = DateTime.tryParse(data['createdAt'] as String) ?? DateTime.now();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    final typeStr = (data['type'] as String?)?.toLowerCase() ?? 'expense';
    final type = typeStr == 'income' ? TransactionType.income : TransactionType.expense;
    final desc = (data['description'] as String?) ?? (data['title'] as String?) ?? '';

    return TransactionItem(
      id: docId,
      userId: (data['userId'] as String?) ?? 'default_user',
      title: (data['title'] as String?) ?? desc,
      description: desc,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      type: type,
      categoryId: (data['categoryId'] as String?) ?? 'others',
      date: parsedDate,
      paymentMethod: (data['paymentMethod'] as String?) ?? 'Bank Account',
      notes: data['notes'] as String?,
      createdAt: parsedCreatedAt,
    );
  }
}
