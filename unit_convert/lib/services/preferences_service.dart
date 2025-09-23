import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversion_history.dart';

class PreferencesService {
  static const String _historyKey = 'conversion_history'; // clave para guardar el historial
  static const int _maxHistoryItems = 50; // máximo de elementos en el historial

  // Guarda una conversión en el historial
  static Future<void> saveConversion(ConversionHistory conversion) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getConversionHistory();

    // añade la nueva conversión al inicio de la lista
    history.insert(0, conversion);

    // solo mantiene los últimos 50 elementos
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    // guarda la lista actualizada en SharedPreferences como JSON
    final historyJson = history.map((c) => c.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(historyJson));
  }

  static Future<List<ConversionHistory>> getConversionHistory() async {
    final prefs = await SharedPreferences.getInstance(); // obtiene la instancia de SharedPreferences
    final historyString = prefs.getString(_historyKey); // obtiene el string guardado

    if (historyString == null) return []; // si no hay historial, devuelve una lista vacía

    try {
      final historyJson = jsonDecode(historyString) as List; // decodifica el JSON
      return historyJson.map((json) => ConversionHistory.fromJson(json)).toList();// convierte cada elemento JSON a ConversionHistory
    } catch (e) {
      // si hay un error al decodificar, devuelve una lista vacía
      return [];
    }
  }

  // Limpia todo el historial guardado
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}