import '../models/conversion_rates.dart';

class ConversionService {
  static double convert(double input, String fromUnit, String toUnit) {
    double meters = input * conversionRates[fromUnit]!;
    return meters / conversionRates[toUnit]!;
  }
}
