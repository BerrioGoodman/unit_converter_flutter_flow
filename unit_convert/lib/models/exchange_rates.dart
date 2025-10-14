class ExchangeRates {
  final Map<String, double> rates;
  final String base;
  final DateTime timestamp;

  ExchangeRates({
    required this.rates,
    required this.base,
    required this.timestamp,
  });

factory ExchangeRates.fromJson(Map<String, dynamic> json) {
  final rawRates = json['data'] as Map<String, dynamic>? ?? {};

  // Convertimos cada valor del mapa a double de forma segura
  final convertedRates = rawRates.map((key, value) {
    // (value as num) acepta tanto int como double, y .toDouble() lo convierte
    return MapEntry(key, (value as num).toDouble());
  });

  return ExchangeRates(
    rates: convertedRates,
    base: 'USD', // La base para la API gratuita siempre es USD
    timestamp: DateTime.now(),
  );
}

  Map<String, dynamic> toJson() {
    return {
      'rates': rates,
      'base': base,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  double? getRate(String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return 1.0;

    // If base is USD and we have direct rates
    if (base == 'USD') {
      final fromRate = rates[fromCurrency];
      final toRate = rates[toCurrency];

      if (fromRate != null && toRate != null) {
        return toRate / fromRate;
      }
    }

    // If fromCurrency is the base
    if (fromCurrency == base) {
      return rates[toCurrency];
    }

    // If toCurrency is the base
    if (toCurrency == base) {
      final fromRate = rates[fromCurrency];
      if (fromRate != null) {
        return 1.0 / fromRate;
      }
    }

    // Cross conversion through base
    final fromRate = rates[fromCurrency];
    final toRate = rates[toCurrency];

    if (fromRate != null && toRate != null) {
      return toRate / fromRate;
    }

    return null;
  }
}