import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversion_history.dart';

class PreferencesService {
  static const String _historyKey = 'conversion_history';
  static const int _maxHistoryItems = 50;

  static Future<void> saveConversion(ConversionHistory conversion) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getConversionHistory();

    // Add new conversion at the beginning
    history.insert(0, conversion);

    // Keep only the most recent items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    // Save to preferences
    final historyJson = history.map((c) => c.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(historyJson));
  }

  static Future<List<ConversionHistory>> getConversionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString(_historyKey);

    if (historyString == null) return [];

    try {
      final historyJson = jsonDecode(historyString) as List;
      return historyJson.map((json) => ConversionHistory.fromJson(json)).toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}