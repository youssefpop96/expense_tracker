import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/loan.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

class AddLoanScreen extends StatefulWidget {
  final Loan? loan;
  const AddLoanScreen({super.key, this.loan});

  @override
  State<AddLoanScreen> createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends State<AddLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isBorrowing = true;
  DateTime _dueDate = DateTime.now();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.loan != null) {
      _isEditing = true;
      _descriptionController.text = widget.loan!.description;
      _amountController.text = widget.loan!.originalAmount.toStringAsFixed(2);
      _isBorrowing = widget.loan!.isBorrowing;
      _dueDate = widget.loan!.dueDate;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveLoan() {
    if (_formKey.currentState!.validate()) {
      final description = _descriptionController.text;
      final amount = double.parse(_amountController.text);

      final newLoan = Loan(
        description: description,
        originalAmount: amount,
        remainingAmount: _isEditing ? widget.loan!.remainingAmount : amount,
        dueDate: _dueDate,
        isBorrowing: _isBorrowing,
      );

      final loansBox = Hive.box<Loan>('loans');
      if (_isEditing) {
        widget.loan!.description = description;
        widget.loan!.originalAmount = amount;
        widget.loan!.dueDate = _dueDate;
        widget.loan!.isBorrowing = _isBorrowing;
        widget.loan!.save();
      } else {
        loansBox.add(newLoan);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editLoan : l10n.addLoan),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.loanDescriptionLabel,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterValidDescription;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.loanAmountLabel,
                ),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.tryParse(value)! <= 0) {
                    return l10n.enterValidAmount;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(l10n.borrowed),
                leading: Radio<bool>(
                  value: true,
                  groupValue: _isBorrowing,
                  onChanged: (bool? value) {
                    setState(() {
                      _isBorrowing = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(l10n.lent),
                leading: Radio<bool>(
                  value: false,
                  groupValue: _isBorrowing,
                  onChanged: (bool? value) {
                    setState(() {
                      _isBorrowing = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                  '${l10n.loanDueDate}: ${_dueDate.toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDueDate(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveLoan,
                child: Text(_isEditing ? l10n.updateLoan : l10n.saveLoan),
              ),
            ],
          ),
        ),
      ),
    );
  }
}