import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/screens/home_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedCountryCode;

  // تعريف الدول ورمز العملة المقابل
  final Map<String, String> _countryCurrencyMap = {
    'EG': 'ج.م', // مصر: الجنيه المصري
    'SA': 'ر.س', // السعودية: الريال السعودي
    'AE': 'د.إ', // الإمارات: الدرهم الإماراتي
    'KW': 'د.ك', // الكويت: الدينار الكويتي
    'BH': 'د.ب', // البحرين: الدينار البحريني
    'OM': 'ر.ع', // عمان: الريال العماني
    'QA': 'ر.ق', // قطر: الريال القطري
  };

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // دالة مساعدة للحصول على اسم الدولة مترجماً
  String _getCountryName(AppLocalizations l10n, String code) {
    switch (code) {
      case 'EG':
        return l10n.egypt;
      case 'SA':
        return l10n.saudiArabia;
      case 'AE':
        return l10n.uae;
      case 'KW':
        return l10n.kuwait;
      case 'BH':
        return l10n.bahrain;
      case 'OM':
        return l10n.oman;
      case 'QA':
        return l10n.qatar;
      default:
        return 'Unknown';
    }
  }

  void _completeSetup(AppLocalizations l10n) async {
    if (_formKey.currentState!.validate()) {
      final settingsBox = Hive.box('settings');

      // 1. حفظ معلومات المستخدم (الاسم، العمر)
      settingsBox.put('username', _usernameController.text);
      settingsBox.put('age', int.tryParse(_ageController.text));

      // 2. تعيين العملة بناءً على الدولة المختارة
      final currencySymbol = _countryCurrencyMap[_selectedCountryCode!];
      settingsBox.put('currencySymbol', currencySymbol);

      // 3. وضع علامة 'setup_complete' لإظهار الشاشة الرئيسية في المرات القادمة
      settingsBox.put('setup_complete', true);

      // 4. الانتقال إلى الشاشة الرئيسية
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setupScreenTitle),
        // منع زر العودة في شاشة الإعداد الأولية
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // حقل اسم المستخدم
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: l10n.usernameLabel,
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterValidUsername;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // حقل العمر
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.ageLabel,
                  prefixIcon: const Icon(Icons.cake_outlined),
                ),
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value)! <= 0) {
                    return l10n.enterValidAge;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // قائمة الدول المنسدلة
              DropdownButtonFormField<String>(
                value: _selectedCountryCode,
                decoration: InputDecoration(
                  labelText: l10n.countryLabel,
                  prefixIcon: const Icon(Icons.flag),
                ),
                hint: Text(l10n.selectCountry),
                items: _countryCurrencyMap.keys.map((String code) {
                  return DropdownMenuItem<String>(
                    value: code,
                    child: Text('${_getCountryName(l10n, code)} (${_countryCurrencyMap[code]})'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountryCode = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return l10n.selectCountry;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // زر بدء التتبع
              ElevatedButton(
                onPressed: () => _completeSetup(l10n),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.startAppButton, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}