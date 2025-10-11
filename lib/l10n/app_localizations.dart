import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Expense Tracker'**
  String get appName;

  /// No description provided for @balanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get balanceTitle;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get expensesTitle;

  /// No description provided for @incomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get incomeTitle;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add New Transaction'**
  String get addTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get addExpense;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get addIncome;

  /// No description provided for @loansTitle.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get loansTitle;

  /// No description provided for @budgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgetsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @enterValidDescriptionAndAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid description and amount.'**
  String get enterValidDescriptionAndAmount;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search transactions...'**
  String get searchHint;

  /// No description provided for @deletedTransaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted successfully.'**
  String get deletedTransaction;

  /// No description provided for @addLoan.
  ///
  /// In en, this message translates to:
  /// **'Add Loan'**
  String get addLoan;

  /// No description provided for @payLoan.
  ///
  /// In en, this message translates to:
  /// **'Pay Loan'**
  String get payLoan;

  /// No description provided for @loan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get loan;

  /// No description provided for @borrowing.
  ///
  /// In en, this message translates to:
  /// **'Borrowing'**
  String get borrowing;

  /// No description provided for @lending.
  ///
  /// In en, this message translates to:
  /// **'Lending'**
  String get lending;

  /// No description provided for @loanScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get loanScreenTitle;

  /// No description provided for @noLoansFound.
  ///
  /// In en, this message translates to:
  /// **'No loans found yet.'**
  String get noLoansFound;

  /// No description provided for @loanDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (e.g., Loan from a friend)'**
  String get loanDescriptionLabel;

  /// No description provided for @loanAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (SAR)'**
  String get loanAmountLabel;

  /// No description provided for @dueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDateLabel;

  /// No description provided for @updateLoan.
  ///
  /// In en, this message translates to:
  /// **'Update Loan'**
  String get updateLoan;

  /// No description provided for @saveLoan.
  ///
  /// In en, this message translates to:
  /// **'Save Loan'**
  String get saveLoan;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @transactionAdded.
  ///
  /// In en, this message translates to:
  /// **'Transaction added successfully.'**
  String get transactionAdded;

  /// No description provided for @editLoan.
  ///
  /// In en, this message translates to:
  /// **'Edit Loan'**
  String get editLoan;

  /// No description provided for @borrowed.
  ///
  /// In en, this message translates to:
  /// **'Borrowed'**
  String get borrowed;

  /// No description provided for @lent.
  ///
  /// In en, this message translates to:
  /// **'Lent'**
  String get lent;

  /// No description provided for @loanDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get loanDueDate;

  /// No description provided for @remainingAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining Amount'**
  String get remainingAmountLabel;

  /// No description provided for @foodCategory.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get foodCategory;

  /// No description provided for @transportationCategory.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportationCategory;

  /// No description provided for @billsCategory.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get billsCategory;

  /// No description provided for @shoppingCategory.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shoppingCategory;

  /// No description provided for @entertainmentCategory.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainmentCategory;

  /// No description provided for @otherCategory.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherCategory;

  /// No description provided for @salaryCategory.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salaryCategory;

  /// No description provided for @bonusCategory.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get bonusCategory;

  /// No description provided for @giftsCategory.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get giftsCategory;

  /// No description provided for @enterValidDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid description.'**
  String get enterValidDescription;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount.'**
  String get enterValidAmount;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found yet.'**
  String get noTransactionsFound;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get byCategory;

  /// No description provided for @byDate.
  ///
  /// In en, this message translates to:
  /// **'By Date'**
  String get byDate;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @noBudgetsFound.
  ///
  /// In en, this message translates to:
  /// **'No budgets found yet.'**
  String get noBudgetsFound;

  /// No description provided for @budgetDeleted.
  ///
  /// In en, this message translates to:
  /// **'Budget deleted successfully.'**
  String get budgetDeleted;

  /// No description provided for @spentTitle.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spentTitle;

  /// No description provided for @budgetGoal.
  ///
  /// In en, this message translates to:
  /// **'Budget Goal'**
  String get budgetGoal;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget'**
  String get editBudget;

  /// No description provided for @addBudget.
  ///
  /// In en, this message translates to:
  /// **'Add Budget'**
  String get addBudget;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @loans.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get loans;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @setupScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Initial Setup'**
  String get setupScreenTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @startAppButton.
  ///
  /// In en, this message translates to:
  /// **'Start Tracking'**
  String get startAppButton;

  /// No description provided for @enterValidUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid username.'**
  String get enterValidUsername;

  /// No description provided for @enterValidAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age.'**
  String get enterValidAge;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Please select your country.'**
  String get selectCountry;

  /// No description provided for @egypt.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get egypt;

  /// No description provided for @saudiArabia.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get saudiArabia;

  /// No description provided for @uae.
  ///
  /// In en, this message translates to:
  /// **'UAE'**
  String get uae;

  /// No description provided for @kuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get kuwait;

  /// No description provided for @bahrain.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get bahrain;

  /// No description provided for @oman.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get oman;

  /// No description provided for @currentCurrency.
  ///
  /// In en, this message translates to:
  /// **'Current Currency'**
  String get currentCurrency;

  /// No description provided for @qatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get qatar;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
