import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/loan.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/screens/add_loan_screen.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final loansBox = Hive.box<Loan>('loans');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loansTitle),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: loansBox.listenable(),
        builder: (context, box, _) {
          final loans = box.values.toList().cast<Loan>();
          if (loans.isEmpty) {
            return Center(child: Text(l10n.noLoansFound));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              final progress = (loan.originalAmount - loan.remainingAmount) / loan.originalAmount;
              final isBorrowing = loan.isBorrowing;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    loan.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${l10n.amountLabel}: ${loan.originalAmount.toStringAsFixed(2)}'),
                      Text('${l10n.loanDueDate}: ${loan.dueDate.toString().split(' ')[0]}'),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        color: isBorrowing ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.remainingAmountLabel}: ${loan.remainingAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isBorrowing ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddLoanScreen(loan: loan),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.payment, color: Colors.green),
                        onPressed: () => _showAddPaymentDialog(context, loan),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          loan.delete();
                        },
                      ),
                    ],
                  ),
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
              builder: (context) => const AddLoanScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context, Loan loan) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.payLoan),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.amountLabel,
              ),
              validator: (value) {
                final amount = double.tryParse(value ?? '');
                if (amount == null || amount <= 0 || amount > loan.remainingAmount) {
                  return l10n.enterValidAmount;
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final paymentAmount = double.parse(amountController.text);
                  loan.remainingAmount -= paymentAmount;
                  if (loan.remainingAmount < 0) {
                    loan.remainingAmount = 0;
                  }
                  loan.save();
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