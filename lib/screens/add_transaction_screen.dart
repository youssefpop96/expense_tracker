import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late bool _isExpense;
  late String _selectedCategory;

  late List<String> expenseCategories;
  late List<String> incomeCategories;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    _selectedDate = DateTime.now();
    _isExpense = true;
    _selectedCategory = '';
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

    incomeCategories = [
      l10n.salaryCategory,
      l10n.bonusCategory,
      l10n.giftsCategory,
      l10n.otherCategory,
    ];

    if (widget.transaction != null) {
      _descriptionController.text = widget.transaction!.description;
      _amountController.text = widget.transaction!.amount.toString();
      _selectedDate = widget.transaction!.date;
      _isExpense = widget.transaction!.isExpense;
      _selectedCategory = widget.transaction!.category;
    } else {
      _selectedCategory = expenseCategories[0];
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final newTransaction = Transaction(
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        isExpense: _isExpense,
        category: _selectedCategory,
      );

      final transactionBox = Hive.box<Transaction>('transactions');
      if (widget.transaction == null) {
        transactionBox.add(newTransaction);
      } else {
        widget.transaction!
          ..description = newTransaction.description
          ..amount = newTransaction.amount
          ..date = newTransaction.date
          ..isExpense = newTransaction.isExpense
          ..category = newTransaction.category
          ..save();
      }

      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categoryList = _isExpense ? expenseCategories : incomeCategories;

    if (!categoryList.contains(_selectedCategory)) {
      _selectedCategory = categoryList[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction != null ? l10n.editTransaction : l10n.addTransaction,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: Text(l10n.addExpense),
                    selected: _isExpense,
                    selectedColor: Colors.red.shade100,
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: _isExpense ? Colors.red : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _isExpense = true;
                        _selectedCategory = expenseCategories[0];
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: Text(l10n.addIncome),
                    selected: !_isExpense,
                    selectedColor: Colors.green.shade100,
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: !_isExpense ? Colors.green : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _isExpense = false;
                        _selectedCategory = incomeCategories[0];
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.descriptionLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.enterValidDescription;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.amountLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || double.tryParse(value) == null || double.tryParse(value)! <= 0) {
                            return l10n.enterValidAmount;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: l10n.categoryLabel,
                          border: const OutlineInputBorder(),
                        ),
                        items: categoryList.map((String value) {
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
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.dateLabel),
                        subtitle: Text(DateFormat.yMd().format(_selectedDate)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _saveTransaction,
                child: Text(
                  l10n.saveButton,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}