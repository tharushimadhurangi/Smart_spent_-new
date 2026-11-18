import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/transaction_provider.dart';
import 'edit_transaction_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final TransactionType? initialTypeFilter;
  final String? initialCategoryFilter;

  const TransactionHistoryScreen({
    super.key,
    this.initialTypeFilter,
    this.initialCategoryFilter,
  });

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  TransactionType? _typeFilter;
  String? _categoryFilter;

  @override
  void initState() {
    super.initState();
    _typeFilter = widget.initialTypeFilter;
    _categoryFilter = widget.initialCategoryFilter;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF070B19);
    const cardDark = Color(0xFF131A38);
    const borderDark = Color(0xFF232D56);
    const textMuted = Color(0xFF8E9BB5);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearchVisible ? Icons.close_rounded : Icons.search_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            var items = provider.transactions;

            // Type filter
            if (_typeFilter != null) {
              items = items.where((t) => t.type == _typeFilter).toList();
            }

            // Category filter
            if (_categoryFilter != null) {
              items = items.where((t) => t.categoryId == _categoryFilter).toList();
            }

            // Search query
            final query = _searchController.text.trim().toLowerCase();
            if (query.isNotEmpty) {
              items = items.where((t) {
                return t.title.toLowerCase().contains(query) ||
                    t.category.name.toLowerCase().contains(query);
              }).toList();
            }

            return Column(
              children: [
                // Search Input (Collapsible)
                if (_isSearchVisible)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search transactions...',
                        hintStyle: const TextStyle(color: textMuted),
                        filled: true,
                        fillColor: cardDark,
                        prefixIcon: const Icon(Icons.search, color: textMuted, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: borderDark),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: borderDark),
                        ),
                      ),
                    ),
                  ),

                // Filter Pills: All / Income / Expense (Matching Screen 4)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                  child: Row(
                    children: [
                      _buildPill(
                        label: 'All',
                        isSelected: _typeFilter == null,
                        onTap: () => setState(() => _typeFilter = null),
                      ),
                      const SizedBox(width: 10),
                      _buildPill(
                        label: 'Income',
                        isSelected: _typeFilter == TransactionType.income,
                        onTap: () => setState(() => _typeFilter = TransactionType.income),
                      ),
                      const SizedBox(width: 10),
                      _buildPill(
                        label: 'Expense',
                        isSelected: _typeFilter == TransactionType.expense,
                        onTap: () => setState(() => _typeFilter = TransactionType.expense),
                      ),
                    ],
                  ),
                ),

                // Transactions List
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'No transactions found',
                            style: TextStyle(color: textMuted, fontSize: 15),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                          itemCount: items.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final tx = items[index];
                            final cat = tx.category;
                            final isIncome = tx.type == TransactionType.income;
                            final amountColor = isIncome
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTransactionScreen(transaction: tx),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: cardDark,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: borderDark, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    // Circular Category Icon (matching Screen 4)
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: cat.color.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: cat.color.withValues(alpha: 0.4),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        cat.icon,
                                        color: cat.color,
                                        size: 22,
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    // Title & Date
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tx.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            tx.formattedDate,
                                            style: const TextStyle(
                                              color: textMuted,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Amount
                                    Text(
                                      tx.formattedAmount,
                                      style: TextStyle(
                                        color: amountColor,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    // Chevron right
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: textMuted,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B5CF6)
              : const Color(0xFF131A38),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : const Color(0xFF232D56),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8E9BB5),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
