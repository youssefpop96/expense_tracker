import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _timeFilter = 'month'; // 'week', 'month', 'year'
  bool _showExpenses = true;

  final Map<String, IconData> _categoryIcons = {
    'Food': Icons.restaurant,
    'Transportation': Icons.directions_bus,
    'Bills': Icons.receipt_long,
    'Shopping': Icons.shopping_bag,
    'Entertainment': Icons.sports_esports,
    'Other': Icons.category,
    'Salary': Icons.attach_money,
    'Bonus': Icons.card_giftcard,
    'Gifts': Icons.cake,
  };

  void _updateTimeFilter(String filter) {
    setState(() {
      _timeFilter = filter;
      _endDate = DateTime.now();
      if (filter == 'week') {
        _startDate = DateTime.now().subtract(const Duration(days: 7));
      } else if (filter == 'month') {
        _startDate = DateTime.now().subtract(const Duration(days: 30));
      } else if (filter == 'year') {
        _startDate = DateTime.now().subtract(const Duration(days: 365));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final transactionBox = Hive.box<Transaction>('transactions');
    final settingsBox = Hive.box('settings');
    final currencySymbol = settingsBox.get('currencySymbol', defaultValue: 'ر.س');
    final String languageCode = settingsBox.get('languageCode', defaultValue: 'ar');

    Map<String, IconData> categoryIcons = {};
    if (languageCode == 'ar') {
      categoryIcons = {
        l10n.foodCategory: Icons.restaurant,
        l10n.transportationCategory: Icons.directions_bus,
        l10n.billsCategory: Icons.receipt_long,
        l10n.shoppingCategory: Icons.shopping_bag,
        l10n.entertainmentCategory: Icons.sports_esports,
        l10n.otherCategory: Icons.category,
        l10n.salaryCategory: Icons.attach_money,
        l10n.bonusCategory: Icons.card_giftcard,
        l10n.giftsCategory: Icons.cake,
      };
    } else {
      categoryIcons = _categoryIcons;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analyticsTitle),
      ),
      body: ValueListenableBuilder(
        valueListenable: transactionBox.listenable(),
        builder: (context, box, _) {
          final transactions = box.values
              .where((t) =>
          t.date.isAfter(_startDate) && t.date.isBefore(_endDate))
              .toList();

          if (transactions.isEmpty) {
            return Center(child: Text(l10n.noTransactionsFound));
          }

          final filteredTransactions = transactions
              .where((t) => t.isExpense == _showExpenses)
              .toList();

          final Map<String, double> categoryData = {};
          for (var t in filteredTransactions) {
            if (categoryData.containsKey(t.category)) {
              categoryData[t.category] = categoryData[t.category]! + t.amount;
            } else {
              categoryData[t.category] = t.amount;
            }
          }

          final List<BarChartGroupData> barGroups = categoryData.entries
              .map((entry) {
            final categoryName = entry.key;
            final categoryAmount = entry.value;
            final categoryIndex = categoryData.keys.toList().indexOf(categoryName);
            return BarChartGroupData(
              x: categoryIndex,
              barRods: [
                BarChartRodData(
                  toY: categoryAmount,
                  color: _showExpenses ? Colors.red : Colors.green,
                  width: 15,
                ),
              ],
            );
          }).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFilterButton(l10n.week, 'week'),
                      _buildFilterButton(l10n.month, 'month'),
                      _buildFilterButton(l10n.year, 'year'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.expensesTitle),
                        selected: _showExpenses,
                        onSelected: (selected) {
                          setState(() {
                            _showExpenses = selected;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: Text(l10n.incomeTitle),
                        selected: !_showExpenses,
                        onSelected: (selected) {
                          setState(() {
                            _showExpenses = !selected;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Card(
                      color: Theme.of(context).cardColor,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: barGroups,
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final categoryIndex = value.toInt();
                                    if (categoryIndex >= 0 && categoryIndex < categoryData.keys.length) {
                                      final categoryName = categoryData.keys.toList()[categoryIndex];
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(categoryName, style: const TextStyle(fontSize: 10)),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${value.toInt()}',
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.byCategory, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  ...categoryData.entries.map((entry) {
                    final category = entry.key;
                    final totalAmount = entry.value;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            categoryIcons[category] ?? Icons.category,
                            color: _showExpenses ? Colors.red : Colors.green,
                          ),
                        ),
                        title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text(
                          '${totalAmount.toStringAsFixed(2)} $currencySymbol',
                          style: TextStyle(
                            color: _showExpenses ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterButton(String text, String filter) {
    return TextButton(
      onPressed: () => _updateTimeFilter(filter),
      child: Text(
        text,
        style: TextStyle(
          color: _timeFilter == filter ? Colors.white : Colors.grey,
          fontWeight: _timeFilter == filter ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}