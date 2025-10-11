import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/screens/add_transaction_screen.dart';
import 'package:expense_tracker/screens/analytics_screen.dart';
import 'package:expense_tracker/screens/loans_screen.dart';
import 'package:expense_tracker/screens/budget_screen.dart';
import 'package:expense_tracker/screens/settings_screen.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/services.dart'; // لإخفاء لوحة المفاتيح

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // تعريف الأيقونات باللغة العربية للتعامل مع الترجمة
  late final Map<String, IconData> categoryIcons;

  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    // تحديث خريطة الأيقونات بناءً على اللغة الحالية
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // دالة مساعدة لبناء عناصر الدخل والمصروفات
  Widget _buildSummaryItem(String title, double amount, String currencySymbol, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${amount.toStringAsFixed(2)} $currencySymbol',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AnalyticsScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BudgetScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoansScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchText = '';
                      // إخفاء لوحة المفاتيح
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
        ),
      ),

      // نستمع لتغييرات إعدادات العملة
      body: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, settingsBox, _) {
          final currencySymbol = settingsBox.get('currencySymbol', defaultValue: 'ر.س');

          // نستمع لتغييرات قائمة المعاملات
          return ValueListenableBuilder<Box<Transaction>>(
            valueListenable: Hive.box<Transaction>('transactions').listenable(),
            builder: (context, box, _) {
              // 1. حساب الإجماليات
              final allTransactions = box.values.toList().cast<Transaction>();
              final filteredTransactions = allTransactions.where((transaction) {
                return transaction.description.toLowerCase().contains(_searchText.toLowerCase());
              }).toList();

              final totalExpenses = filteredTransactions
                  .where((t) => t.isExpense)
                  .fold<double>(0.0, (sum, t) => sum + t.amount);

              final totalIncome = filteredTransactions
                  .where((t) => !t.isExpense)
                  .fold<double>(0.0, (sum, t) => sum + t.amount);

              final totalBalance = totalIncome - totalExpenses;

              return SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.balanceTitle, // "الرصيد الإجمالي"
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${totalBalance.toStringAsFixed(2)} $currencySymbol',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: totalBalance >= 0 ? Colors.purpleAccent : Colors.redAccent,
                              ),
                            ),
                            const Divider(height: 30, color: Colors.white12),

                            // صف الدخل والمصروفات
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSummaryItem(
                                  l10n.incomeTitle, // "إجمالي الدخل"
                                  totalIncome,
                                  currencySymbol,
                                  Colors.green,
                                ),
                                _buildSummaryItem(
                                  l10n.expensesTitle, // "إجمالي المصاريف"
                                  totalExpenses,
                                  currencySymbol,
                                  Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.recentTransactions,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (filteredTransactions.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text(
                            l10n.noTransactionsFound,
                            style: const TextStyle(color: Colors.white60),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredTransactions.length > 5 && _searchText.isEmpty
                            ? 5
                            : filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          return Dismissible(
                            key: ValueKey(transaction.key),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              transaction.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.deletedTransaction),
                                ),
                              );
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AddTransactionScreen(
                                        transaction: transaction,
                                      ),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF1F1F1F),
                                  child: Icon(
                                    categoryIcons[transaction.category] ?? Icons.category,
                                    color: transaction.isExpense ? Colors.red : Colors.green,
                                  ),
                                ),
                                title: Text(
                                  transaction.description,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${transaction.date.toString().split(' ')[0]} | ${transaction.category}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Text(
                                  '${transaction.isExpense ? '-' : '+'}${transaction.amount.toStringAsFixed(2)} $currencySymbol',
                                  style: TextStyle(
                                    color: transaction.isExpense ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}