import '../models/conversion_rates.dart';

class ConversionService {
  static double? convert(double value, String fromUnit, String toUnit, Map<String, double> rates) 
  {
    if(value < 0) return null; // Manejo de valores negativos
    if(!rates.containsKey(fromUnit) || !rates.containsKey(toUnit)) return null; // Manejo de unidades no válidas

    double baseValue = value / rates[fromUnit]!;
    return baseValue * rates[toUnit]!;
  }
}
