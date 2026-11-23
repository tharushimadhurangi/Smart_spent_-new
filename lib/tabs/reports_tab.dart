import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  TimePeriodFilter selectedPeriod = TimePeriodFilter.allTime;

  static const purple = Color(0xFF702BFF);
  static const green = Color(0xFF16A34A);
  static const red = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final theme = Theme.of(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = provider.filterByPeriod(
      provider.transactions,
      selectedPeriod,
    );

    final income = _total(items, true);
    final expenses = _total(items, false);
    final savings = income - expenses;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports & Analytics',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Automatically updated financial reports',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<TimePeriodFilter>(
              initialValue: selectedPeriod,
              decoration: const InputDecoration(
                labelText: 'Select Period',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: TimePeriodFilter.allTime,
                  child: Text('All Time'),
                ),
                DropdownMenuItem(
                  value: TimePeriodFilter.today,
                  child: Text('Today'),
                ),
                DropdownMenuItem(
                  value: TimePeriodFilter.thisWeek,
                  child: Text('This Week'),
                ),
                DropdownMenuItem(
                  value: TimePeriodFilter.thisMonth,
                  child: Text('This Month'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedPeriod = value);
                }
              },
            ),
            const SizedBox(height: 20),
            _summaryCard(
              'Total Income',
              income,
              green,
              Icons.trending_up,
            ),
            _summaryCard(
              'Total Expenses',
              expenses,
              red,
              Icons.trending_down,
            ),
            _summaryCard(
              'Total Savings',
              savings,
              purple,
              Icons.savings_outlined,
            ),
            const SizedBox(height: 24),
            _chartCard(
              'Income vs Expenses',
              _incomeExpenseChart(income, expenses),
            ),
            _chartCard(
              'Monthly Income',
              _monthlyChart(items, true),
            ),
            _chartCard(
              'Monthly Expenses',
              _monthlyChart(items, false),
            ),
            _chartCard(
              'Monthly Savings',
              _savingsChart(items),
            ),
            _chartCard(
              'Category-wise Expenses',
              _categoryChart(items),
            ),
          ],
        ),
      ),
    );
  }

  double _total(List<TransactionItem> items, bool income) {
    return items
        .where((t) => income ? t.isIncome : t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Widget _summaryCard(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title),
        subtitle: Text(
          'LKR ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _chartCard(String title, Widget chart) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(height: 250, child: chart),
          ],
        ),
      ),
    );
  }

  Widget _incomeExpenseChart(
    double income,
    double expenses,
  ) {
    final maximum = [
      income,
      expenses,
      1.0,
    ].reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: maximum * 1.2,
        alignment: BarChartAlignment.spaceAround,
        barGroups: [
          _bar(0, income, green),
          _bar(1, expenses, red),
        ],
        titlesData: _titles(['Income', 'Expense']),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  BarChartGroupData _bar(
    int x,
    double amount,
    Color color,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: amount,
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }

  FlTitlesData _titles(List<String> labels) {
    return FlTitlesData(
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= labels.length) {
              return const SizedBox.shrink();
            }
            return SideTitleWidget(
              meta: meta,
              child: Text(
                labels[index],
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
        ),
      ),
    );
  }

  // Group transactions by calendar month
  Map<DateTime, double> _monthlyTotals(
    List<TransactionItem> items,
    bool income,
  ) {
    final result = <DateTime, double>{};

    for (final tx in items) {
      if (income ? !tx.isIncome : !tx.isExpense) {
        continue;
      }

      final month = DateTime(tx.date.year, tx.date.month);
      result[month] = (result[month] ?? 0) + tx.amount;
    }

    return result;
  }

  List<DateTime> _months(List<TransactionItem> items) {
    final months = items
        .map((t) => DateTime(t.date.year, t.date.month))
        .toSet()
        .toList()
      ..sort();

    return months;
  }

  String _monthLabel(DateTime date) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${names[date.month - 1]} ${date.year % 100}';
  }

  Widget _monthlyChart(
    List<TransactionItem> items,
    bool income,
  ) {
    final months = _months(items);
    if (months.isEmpty) return _emptyChart();

    final totals = _monthlyTotals(items, income);
    final color = income ? green : red;

    final groups = <BarChartGroupData>[];
    double maxAmount = 1;

    for (var i = 0; i < months.length; i++) {
      final amount = totals[months[i]] ?? 0;
      if (amount > maxAmount) maxAmount = amount;
      groups.add(_bar(i, amount, color));
    }

    return BarChart(
      BarChartData(
        maxY: maxAmount * 1.2,
        barGroups: groups,
        titlesData: _titles(
          months.map(_monthLabel).toList(),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _savingsChart(List<TransactionItem> items) {
    final months = _months(items);
    if (months.isEmpty) return _emptyChart();

    final incomes = _monthlyTotals(items, true);
    final expenses = _monthlyTotals(items, false);

    final savings = months.map((month) {
      return (incomes[month] ?? 0) - (expenses[month] ?? 0);
    }).toList();

    double minAmount = 0;
    double maxAmount = 1;

    for (final value in savings) {
      if (value < minAmount) minAmount = value;
      if (value > maxAmount) maxAmount = value;
    }

    final padding = (maxAmount - minAmount) * 0.1;

    return BarChart(
      BarChartData(
        minY: minAmount - padding,
        maxY: maxAmount + padding,
        barGroups: [
          for (var i = 0; i < savings.length; i++)
            _bar(
              i,
              savings[i],
              savings[i] >= 0 ? purple : red,
            ),
        ],
        titlesData: _titles(
          months.map(_monthLabel).toList(),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _categoryChart(List<TransactionItem> items) {
    final categories = <String, double>{};

    for (final tx in items.where((t) => t.isExpense)) {
      categories[tx.categoryId] = (categories[tx.categoryId] ?? 0) + tx.amount;
    }

    if (categories.isEmpty) return _emptyChart();

    final entries = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.value,
    );

    if (total <= 0) return _emptyChart();

    const colors = [
      Color(0xFF702BFF),
      Color(0xFF16A34A),
      Color(0xFFEF4444),
      Color(0xFFF59E0B),
      Color(0xFF3B82F6),
      Color(0xFFEC4899),
    ];

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: [
                for (var i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    value: entries[i].value,
                    color: colors[i % colors.length],
                    title:
                        '${(entries[i].value / total * 100).toStringAsFixed(0)}%',
                    radius: 85,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
              sectionsSpace: 3,
              centerSpaceRadius: 25,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            for (var i = 0; i < entries.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: colors[i % colors.length],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    entries[i].key,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _emptyChart() {
    return const Center(
      child: Text('No transaction data available'),
    );
  }
}
