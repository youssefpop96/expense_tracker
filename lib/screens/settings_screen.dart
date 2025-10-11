import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // تعريف الدول ورمز العملة المقابل - يجب أن يكون مطابقًا لما في SetupScreen
  final Map<String, String> _countryCurrencyMap = {
    'EG': 'ج.م', // مصر: الجنيه المصري
    'SA': 'ر.س', // السعودية: الريال السعودي
    'AE': 'د.إ', // الإمارات: الدرهم الإماراتي
    'KW': 'د.ك', // الكويت: الدينار الكويتي
    'BH': 'د.ب', // البحرين: الدينار البحريني
    'OM': 'ر.ع', // عمان: الريال العماني
    'QA': 'ر.ق', // قطر: الريال القطري
  };

  late String? _selectedCountryCode;
  late String _selectedLanguage;
  late String _currentCurrencySymbol;

  @override
  void initState() {
    super.initState();
    final settingsBox = Hive.box('settings');
    // جلب العملة الحالية من Hive
    _currentCurrencySymbol = settingsBox.get('currencySymbol', defaultValue: 'ر.س');

    // محاولة تحديد رمز الدولة الحالي بناءً على رمز الدولة المحفوظ (أو العملة إذا لم يكن رمز الدولة محفوظًا)
    _selectedCountryCode = settingsBox.get('countryCode');

    if (_selectedCountryCode == null) {
      // إذا لم يكن رمز الدولة محفوظًا، نحاول استنتاجه من رمز العملة
      _selectedCountryCode = _countryCurrencyMap.entries
          .firstWhere((entry) => entry.value == _currentCurrencySymbol,
          orElse: () => const MapEntry('SA', 'ر.س')) // الافتراضي هو السعودية
          .key;
    }

    _selectedLanguage = settingsBox.get('languageCode', defaultValue: 'ar');
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
      // نستخدم رمز الدولة كاسم افتراضي إذا لم يتم العثور على ترجمة
        return code;
    }
  }

  // دالة لحفظ الدولة والعملة المرتبطة بها
  void _saveCountry(String? newCountryCode) {
    if (newCountryCode != null) {
      final newCurrencySymbol = _countryCurrencyMap[newCountryCode]!;
      setState(() {
        _selectedCountryCode = newCountryCode;
        _currentCurrencySymbol = newCurrencySymbol;
      });
      // احفظ رمز العملة الجديد ورمز الدولة في Hive
      Hive.box('settings').put('currencySymbol', newCurrencySymbol);
      Hive.box('settings').put('countryCode', newCountryCode);
    }
  }

  void _saveLanguage(String? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        _selectedLanguage = newLanguage;
      });
      // احفظ اللغة الجديدة في Hive
      Hive.box('settings').put('languageCode', newLanguage);
    }
  }

  @override
  Widget build(BuildContext context) {
    // التأكد من أن الترجمة متاحة
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ------------------------------------
            // قسم اختيار الدولة (تحديث العملة)
            // ------------------------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عرض العملة الحالية كمعلومة إضافية
                  Text(
                      '${l10n.currentCurrency}: $_currentCurrencySymbol',
                      style: const TextStyle(fontSize: 16, color: Colors.white70)
                  ),
                  const SizedBox(height: 10),
                  // قائمة اختيار الدولة
                  DropdownButtonFormField<String>(
                    value: _selectedCountryCode,
                    decoration: InputDecoration(
                      labelText: l10n.countryLabel, // استخدام مفتاح الترجمة "الدولة"
                      prefixIcon: const Icon(Icons.flag),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    items: _countryCurrencyMap.keys.map((String code) {
                      return DropdownMenuItem<String>(
                        value: code,
                        child: Text(
                          // عرض اسم الدولة ورمز عملتها (مثلاً: مصر (ج.م))
                          '${_getCountryName(l10n, code)} (${_countryCurrencyMap[code]})',
                        ),
                      );
                    }).toList(),
                    onChanged: _saveCountry, // دالة لحفظ الدولة والعملة المرتبطة بها
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ------------------------------------
            // قسم اختيار اللغة
            // ------------------------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: InputDecoration(
                  labelText: l10n.languageLabel,
                  prefixIcon: const Icon(Icons.language),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('العربية'),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                ],
                onChanged: _saveLanguage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}