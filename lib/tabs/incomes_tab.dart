import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../providers/transaction_provider.dart';
import '../wideget/transaction_tile.dart';
import '../wideget/transaction_detail_sheet.dart';
import '../screens/transaction_form_sheet.dart';
import '../theme/app_theme.dart';

class IncomesTab extends StatefulWidget {
  const IncomesTab({super.key});

  @override
  State<IncomesTab> createState() => _IncomesTabState();
}

class _IncomesTabState extends State<IncomesTab> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  TimePeriodFilter _periodFilter = TimePeriodFilter.allTime;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = isDark ? AppColors.mutedText : const Color(0xFF65708A);
    final borderColor = isDark ? AppColors.border : const Color(0xFFE1E5F0);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            var incomes = provider.incomeTransactions;

            // Apply Period Filter
            incomes = provider.filterByPeriod(incomes, _periodFilter);

            // Apply Category Filter
            if (_selectedCategory != null) {
              incomes = incomes
                  .where((t) => t.categoryId == _selectedCategory)
                  .toList();
            }

            // Apply Search Filter
            final query = _searchController.text.trim().toLowerCase();
            if (query.isNotEmpty) {
              incomes = incomes.where((t) {
                final inTitle = t.title.toLowerCase().contains(query);
                final inCat = t.category.name.toLowerCase().contains(query);
                final inNotes = t.notes?.toLowerCase().contains(query) ?? false;
                return inTitle || inCat || inNotes;
              }).toList();
            }

            // Top income source
            final breakdown = provider.incomeBreakdownByCategory;
            String topSource = 'None';
            double topSourceAmount = 0.0;
            breakdown.forEach((catId, sum) {
              if (sum > topSourceAmount) {
                topSourceAmount = sum;
                topSource = TransactionCategory.getById(catId, TransactionType.income).name;
              }
            });

            return CustomScrollView(
              slivers: [
                // Header & Summary Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Income Management',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Track and optimize your revenue streams',
                                  style: TextStyle(
                                    color: mutedColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                TransactionFormSheet.show(
                                  context,
                                  defaultType: TransactionType.income,
                                );
                              },
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Add Income'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                minimumSize: const Size(0, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Income Summary Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF065F46), Color(0xFF047857), Color(0xFF10B981)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Income',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 3.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.trending_up_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${provider.incomeTransactions.length} Streams',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Text(
                                TransactionItem.formatCurrency(provider.totalIncome),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 14),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Primary Source:',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      topSource,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Search Bar
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          style: TextStyle(color: textColor, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search income entries...',
                            prefixIcon:
                                const Icon(Icons.search_rounded, size: 20),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded,
                                        size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Period Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildPeriodFilterChip(
                                'All Time',
                                TimePeriodFilter.allTime,
                                isDark,
                              ),
                              const SizedBox(width: 8),
                              _buildPeriodFilterChip(
                                'Today',
                                TimePeriodFilter.today,
                                isDark,
                              ),
                              const SizedBox(width: 8),
                              _buildPeriodFilterChip(
                                'This Week',
                                TimePeriodFilter.thisWeek,
                                isDark,
                              ),
                              const SizedBox(width: 8),
                              _buildPeriodFilterChip(
                                'This Month',
                                TimePeriodFilter.thisMonth,
                                isDark,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Category Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildCategoryFilterChip(
                                id: null,
                                name: 'All Categories',
                                icon: Icons.all_inclusive_rounded,
                                color: AppColors.primary,
                                isDark: isDark,
                                textColor: textColor,
                                borderColor: borderColor,
                              ),
                              const SizedBox(width: 8),
                              ...TransactionCategory.incomeCategories.map((cat) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _buildCategoryFilterChip(
                                    id: cat.id,
                                    name: cat.name,
                                    icon: cat.icon,
                                    color: cat.color,
                                    isDark: isDark,
                                    textColor: textColor,
                                    borderColor: borderColor,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // List Section Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Income Entries (${incomes.length})',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (incomes.isNotEmpty)
                              Text(
                                'Tap to inspect or edit',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Income List or Empty State
                incomes.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 60,
                                  color: mutedColor.withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'No Income Records Found',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tap "+ Add Income" above to register a new income source.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: mutedColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = incomes[index];
                              return TransactionTile(
                                transaction: item,
                                onTap: () => TransactionDetailSheet.show(
                                  context,
                                  item,
                                ),
                              );
                            },
                            childCount: incomes.length,
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPeriodFilterChip(
    String label,
    TimePeriodFilter period,
    bool isDark,
  ) {
    final isSelected = _periodFilter == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          _periodFilter = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.success
              : (isDark ? const Color(0xFF101D35) : const Color(0xFFE5E9F2)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterChip({
    required String? id,
    required String name,
    required IconData icon,
    required Color color,
    required bool isDark,
    required Color textColor,
    required Color borderColor,
  }) {
    final isSelected = _selectedCategory == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : (isDark ? const Color(0xFF101D35) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : borderColor,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? color : textColor.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? color : textColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
