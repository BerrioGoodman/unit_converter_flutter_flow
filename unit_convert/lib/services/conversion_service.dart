
class ConversionService {
  static double? convert(double value, String fromUnit, String toUnit, Map<String, double> rates)
  {
    if(value < 0) return null; // Manejo de valores negativos
    if(!rates.containsKey(fromUnit) || !rates.containsKey(toUnit)) return null; // si no existe la unidad en la lista

    double baseValue = value * rates[fromUnit]!; // Convertir a la unidad base (kg, m, etc.)
    return baseValue / rates[toUnit]!; // Convertir a la unidad deseada
  }

  //temp conversion
  static double? convertTemperature(double value, String fromUnit, String toUnit) 
  {
   
   if(fromUnit == toUnit) return value; // No se necesita una conversión
    double celsiusValue;

    // Convertir a Celsius primero
    switch(fromUnit) 
    {
      case 'Celsius':
        celsiusValue = value;
        break;
      case 'Fahrenheit':
        celsiusValue = (value - 32) * 5/9;
        break;
      case 'Kelvin':
        celsiusValue = value - 273.15;
        break;
      default:
        return null; // Unidad no válida
    }

    // Luego convertir de Celsius a la unidad deseada
    switch(toUnit) 
    {
      case 'Celsius':
        return celsiusValue;
      case 'Fahrenheit':
        return (celsiusValue * 9/5) + 32;
      case 'Kelvin':
        return celsiusValue + 273.15;
      default:
        return null; // Unidad no válida
    }
  }
}
