import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/models/budget.dart';
import 'package:expense_tracker/models/loan.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/screens/setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(LoanAdapter());
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<Budget>('budgets');
  await Hive.openBox<Loan>('loans');
  await Hive.openBox('settings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, settingsBox, _) {
        final languageCode = settingsBox.get('languageCode', defaultValue: 'ar');
        final bool setupComplete = settingsBox.get('setup_complete', defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Expense Tracker',
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFFBB86FC),
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: 'NotoSansArabic',
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFBB86FC),
              secondary: Color(0xFF03DAC6),
              surface: Color(0xFF1F1F1F),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF2C2C2C),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBB86FC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          locale: Locale(languageCode),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: setupComplete ? const HomeScreen() : const SetupScreen(),
        );
      },
    );
  }
}