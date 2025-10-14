import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exchange_rates.dart';

class CurrencyService {
  static const String _apiKey = 'fca_live_yXBqjwfbUfbifunPz8dwmZMKBsJdAZDWm7zMO3Ba'; // Replace with actual API key
  static const String _baseUrl = 'https://api.freecurrencyapi.com/v1';

  static Future<ExchangeRates?> fetchExchangeRates({String base = 'USD'}) async {
    try {
      final url = Uri.parse('$_baseUrl/latest?apikey=$_apiKey&base_currency=$base');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ExchangeRates.fromJson(data);
      } else {
        print('Failed to fetch exchange rates: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching exchange rates: $e');
      return null;
    }
  }

  static double? convertCurrency(double amount, String fromCurrency, String toCurrency, ExchangeRates rates) {
    if (amount <= 0) return null;

    final rate = rates.getRate(fromCurrency, toCurrency);
    if (rate == null) return null;

    return amount * rate;
  }

  // Cache for exchange rates to avoid too many API calls
  static ExchangeRates? _cachedRates;
  static DateTime? _lastFetchTime;

  static Future<ExchangeRates?> getCachedOrFetchRates({String base = 'USD'}) async {
    // Check if we have cached rates and they're less than 1 hour old
    if (_cachedRates != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!).inHours < 1) {
      return _cachedRates;
    }

    // Fetch new rates
    final rates = await fetchExchangeRates(base: base);
    if (rates != null) {
      _cachedRates = rates;
      _lastFetchTime = DateTime.now();
    }

    return rates;
  }
}