import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';

class FirestoreTransactionService {
  FirebaseFirestore? _firestore;
  FirebaseAuth? _auth;

  FirestoreTransactionService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore,
        _auth = auth;

  // Collection Names as required
  static const String incomeCollectionName = 'income';
  static const String expenseCollectionName = 'expense';
  static const String usersCollectionName = 'users';

  /// Check if Firebase has been initialized
  bool get isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  FirebaseFirestore? get firestore {
    if (_firestore != null) return _firestore;
    if (isFirebaseAvailable) {
      try {
        _firestore = FirebaseFirestore.instance;
        return _firestore;
      } catch (e) {
        debugPrint('Firestore instance access error: $e');
      }
    }
    return null;
  }

  FirebaseAuth? get auth {
    if (_auth != null) return _auth;
    if (isFirebaseAvailable) {
      try {
        _auth = FirebaseAuth.instance;
        return _auth;
      } catch (e) {
        debugPrint('FirebaseAuth instance access error: $e');
      }
    }
    return null;
  }

  /// Resolves the relevant userId linked to transactions
  String get currentUserId {
    try {
      final user = auth?.currentUser;
      if (user != null && user.uid.isNotEmpty) {
        return user.uid;
      }
    } catch (_) {}
    return 'user_default';
  }

  // --- Collection References ---

  /// Root 'income' collection
  CollectionReference<Map<String, dynamic>>? get incomeCollection =>
      firestore?.collection(incomeCollectionName);

  /// Root 'expense' collection
  CollectionReference<Map<String, dynamic>>? get expenseCollection =>
      firestore?.collection(expenseCollectionName);

  /// User-specific subcollection: users/{userId}/income
  CollectionReference<Map<String, dynamic>>? userIncomeCollection([String? userId]) {
    final uid = userId ?? currentUserId;
    return firestore
        ?.collection(usersCollectionName)
        .doc(uid)
        .collection(incomeCollectionName);
  }

  /// User-specific subcollection: users/{userId}/expense
  CollectionReference<Map<String, dynamic>>? userExpenseCollection([String? userId]) {
    final uid = userId ?? currentUserId;
    return firestore
        ?.collection(usersCollectionName)
        .doc(uid)
        .collection(expenseCollectionName);
  }

  // --- CRUD Operations ---

  /// Adds a transaction to the appropriate collection (income or expense)
  /// and links it with the relevant user
  Future<void> addTransaction(TransactionItem item, {String? userId}) async {
    if (!isFirebaseAvailable || firestore == null) {
      debugPrint('Firestore offline or uninitialized: transaction saved locally.');
      return;
    }

    try {
      final uid = userId ?? (item.userId.isNotEmpty && item.userId != 'default_user'
          ? item.userId
          : currentUserId);

      final transactionWithUser = item.copyWith(userId: uid);
      final data = transactionWithUser.toFirestore();

      if (item.isIncome) {
        // Save in root 'income' collection linked by userId
        await incomeCollection?.doc(item.id).set(data, SetOptions(merge: true));
        // Also mirror in user subcollection for security rules
        await userIncomeCollection(uid)?.doc(item.id).set(data, SetOptions(merge: true));
      } else {
        // Save in root 'expense' collection linked by userId
        await expenseCollection?.doc(item.id).set(data, SetOptions(merge: true));
        // Also mirror in user subcollection for security rules
        await userExpenseCollection(uid)?.doc(item.id).set(data, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Firestore addTransaction error: $e');
    }
  }

  /// Updates an existing transaction in the Firestore collection
  Future<void> updateTransaction(TransactionItem item, {String? userId}) async {
    if (!isFirebaseAvailable || firestore == null) return;

    try {
      final uid = userId ?? (item.userId.isNotEmpty ? item.userId : currentUserId);
      final data = item.toFirestore();

      if (item.isIncome) {
        await incomeCollection?.doc(item.id).update(data);
        await userIncomeCollection(uid)?.doc(item.id).update(data);
      } else {
        await expenseCollection?.doc(item.id).update(data);
        await userExpenseCollection(uid)?.doc(item.id).update(data);
      }
    } catch (e) {
      debugPrint('Firestore updateTransaction error: $e');
    }
  }

  /// Deletes a transaction from the appropriate Firestore collection
  Future<void> deleteTransaction(
    String id,
    TransactionType type, {
    String? userId,
  }) async {
    if (!isFirebaseAvailable || firestore == null) return;

    try {
      final uid = userId ?? currentUserId;

      if (type == TransactionType.income) {
        await incomeCollection?.doc(id).delete();
        await userIncomeCollection(uid)?.doc(id).delete();
      } else {
        await expenseCollection?.doc(id).delete();
        await userExpenseCollection(uid)?.doc(id).delete();
      }
    } catch (e) {
      debugPrint('Firestore deleteTransaction error: $e');
    }
  }

  // --- Real-time Streams ---

  /// Real-time stream of all income records linked with the relevant user
  Stream<List<TransactionItem>> getIncomeStream({String? userId}) {
    if (!isFirebaseAvailable || incomeCollection == null) {
      return Stream.value([]);
    }

    final uid = userId ?? currentUserId;
    return incomeCollection!
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionItem.fromFirestore(doc.data(), doc.id);
      }).toList();
    }).handleError((error) {
      debugPrint('Firestore getIncomeStream error: $error');
      return <TransactionItem>[];
    });
  }

  /// Real-time stream of all expense records linked with the relevant user
  Stream<List<TransactionItem>> getExpenseStream({String? userId}) {
    if (!isFirebaseAvailable || expenseCollection == null) {
      return Stream.value([]);
    }

    final uid = userId ?? currentUserId;
    return expenseCollection!
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionItem.fromFirestore(doc.data(), doc.id);
      }).toList();
    }).handleError((error) {
      debugPrint('Firestore getExpenseStream error: $error');
      return <TransactionItem>[];
    });
  }

  /// Combined real-time stream of all transactions (income + expense) sorted by date
  Stream<List<TransactionItem>> getAllTransactionsStream({String? userId}) {
    final uid = userId ?? currentUserId;

    final incomeStream = getIncomeStream(userId: uid);
    final expenseStream = getExpenseStream(userId: uid);

    final controller = StreamController<List<TransactionItem>>();
    List<TransactionItem> latestIncomes = [];
    List<TransactionItem> latestExpenses = [];

    void emitMerged() {
      final merged = [...latestIncomes, ...latestExpenses];
      merged.sort((a, b) => b.date.compareTo(a.date));
      if (!controller.isClosed) {
        controller.add(merged);
      }
    }

    final incomeSub = incomeStream.listen((incomes) {
      latestIncomes = incomes;
      emitMerged();
    }, onError: controller.addError);

    final expenseSub = expenseStream.listen((expenses) {
      latestExpenses = expenses;
      emitMerged();
    }, onError: controller.addError);

    controller.onCancel = () {
      incomeSub.cancel();
      expenseSub.cancel();
    };

    return controller.stream;
  }

  // --- Future-based One-time Fetches ---

  /// Fetch all incomes for the relevant user
  Future<List<TransactionItem>> fetchIncomes({String? userId}) async {
    if (!isFirebaseAvailable || incomeCollection == null) return [];

    final uid = userId ?? currentUserId;
    try {
      final querySnapshot = await incomeCollection!
          .where('userId', isEqualTo: uid)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return TransactionItem.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Firestore fetchIncomes error: $e');
      return [];
    }
  }

  /// Fetch all expenses for the relevant user
  Future<List<TransactionItem>> fetchExpenses({String? userId}) async {
    if (!isFirebaseAvailable || expenseCollection == null) return [];

    final uid = userId ?? currentUserId;
    try {
      final querySnapshot = await expenseCollection!
          .where('userId', isEqualTo: uid)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return TransactionItem.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Firestore fetchExpenses error: $e');
      return [];
    }
  }

  /// Fetch all transactions for the relevant user
  Future<List<TransactionItem>> fetchAllTransactions({String? userId}) async {
    if (!isFirebaseAvailable) return [];

    final uid = userId ?? currentUserId;
    final results = await Future.wait([
      fetchIncomes(userId: uid),
      fetchExpenses(userId: uid),
    ]);

    final all = [...results[0], ...results[1]];
    all.sort((a, b) => b.date.compareTo(a.date));
    return all;
  }
}
