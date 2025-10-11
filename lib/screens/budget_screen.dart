import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/budget.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedCategory;
  final _amountController = TextEditingController();
  late List<String> expenseCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'طعام'; // Initialize with a default value
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    expenseCategories = [
      l10n.foodCategory,
      l10n.transportationCategory,
      l10n.billsCategory,
      l10n.shoppingCategory,
      l10n.entertainmentCategory,
      l10n.otherCategory,
    ];
    if (!expenseCategories.contains(_selectedCategory)) {
      _selectedCategory = expenseCategories[0];
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.budgetsTitle),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, settingsBox, _) {
          final currencySymbol = settingsBox.get('currencySymbol', defaultValue: 'ر.س');

          return ValueListenableBuilder(
            valueListenable: Hive.box<Budget>('budgets').listenable(),
            builder: (context, box, _) {
              if (box.isEmpty) {
                return Center(
                  child: Text(l10n.noBudgetsFound),
                );
              }
              final budgets = box.values.toList();
              return ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  final categoryExpenses = Hive.box<Transaction>('transactions')
                      .values
                      .where((t) => t.isExpense && t.category == budget.category)
                      .fold(0.0, (sum, item) => sum + item.amount);
                  final progress = categoryExpenses / budget.amount;
                  final progressColor = progress > 1 ? Colors.red : Colors.green;

                  return Dismissible(
                    key: Key(budget.key.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      budget.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.budgetDeleted)),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  budget.category,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.grey),
                                  onPressed: () => _showAddBudgetDialog(context, budget),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              backgroundColor: Colors.grey[800],
                              color: progressColor,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${l10n.spentTitle}: ${categoryExpenses.toStringAsFixed(2)} $currencySymbol',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '${l10n.budgetGoal}: ${budget.amount.toStringAsFixed(2)} $currencySymbol',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context),
        backgroundColor: const Color(0xFFBB86FC),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, [Budget? budget]) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = budget != null;

    if (isEditing) {
      _selectedCategory = budget.category;
      _amountController.text = budget.amount.toString();
    } else {
      _amountController.clear();
      if (expenseCategories.isNotEmpty) {
        _selectedCategory = expenseCategories[0];
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? l10n.editBudget : l10n.addBudget),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.categoryLabel,
                  ),
                  items: expenseCategories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: l10n.amountLabel),
                  validator: (value) {
                    if (value == null ||
                        double.tryParse(value) == null ||
                        double.tryParse(value)! <= 0) {
                      return l10n.enterValidAmount;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final amount = double.parse(_amountController.text);
                  if (budget == null) {
                    final newBudget = Budget(
                      category: _selectedCategory,
                      amount: amount,
                    );
                    Hive.box<Budget>('budgets').add(newBudget);
                  } else {
                    budget.category = _selectedCategory;
                    budget.amount = amount;
                    budget.save();
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(l10n.saveButton),
            ),
          ],
        );
      },
    );
  }
}