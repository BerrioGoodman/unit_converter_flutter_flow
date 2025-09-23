import 'package:flutter/material.dart';
import '../models/temperature_units.dart';
import '../services/conversion_service.dart';
import '../models/conversion_history.dart';
import '../services/preferences_service.dart';

class TemperatureConverterScreen extends StatefulWidget {
  @override
  _TemperatureConverterScreenState createState() => _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState extends State<TemperatureConverterScreen> {
  final TextEditingController _controller = TextEditingController(); //controla lo que escribe el usuario
  String _fromUnit = 'Celsius';
  String _toUnit = 'Fahrenheit';
  double? _result;

  // colores de la aplicación
  final Color pastelBackground = const Color(0xFFF8F1F1);
  final Color pastelPrimary = const Color(0xFFA3C9A8);
  final Color pastelAccent = const Color(0xFFFFDAB9);

  // Íconos por unidad
  final Map<String, IconData> unitIcons = {
    'Celsius': Icons.thermostat,
    'Fahrenheit': Icons.local_fire_department,
    'Kelvin': Icons.ac_unit,
  };

  void _convert() {
    double? input = double.tryParse(_controller.text);
    if (input != null) {
      final result = ConversionService.convertTemperature(input, _fromUnit, _toUnit);//función específica para temperatura
      setState(() {
        _result = result;
      });

      // Guardar en historial si la conversión fue exitosa
      if (result != null) {
        final conversion = ConversionHistory(
          type: 'temperature',
          inputValue: input,
          fromUnit: _fromUnit,
          toUnit: _toUnit,
          result: result,
          timestamp: DateTime.now(),
        );
        PreferencesService.saveConversion(conversion);
      }
    } else {
      setState(() {
        _result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelBackground,
      appBar: AppBar(
        title: const Text(
          'Conversor de Temperatura',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: pastelPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Caja de texto
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Ingrese un valor',
                labelStyle: TextStyle(color: pastelPrimary),
                prefixIcon: Icon(Icons.thermostat, color: pastelPrimary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) => _convert(),
            ),
            const SizedBox(height: 20),

            // Dropdowns alineados
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDropdown(_fromUnit, (value) {
                  setState(() => _fromUnit = value!);
                  _convert();
                }),
                Icon(Icons.swap_horiz, color: pastelAccent, size: 28),
                _buildDropdown(_toUnit, (value) {
                  setState(() => _toUnit = value!);
                  _convert();
                }),
              ],
            ),
            const SizedBox(height: 40),

            // Resultado estilizado con fondo blanco y sombra
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _result == null
                      ? 'Ingrese un número válido'
                      : 'Resultado:\n${_result!.toStringAsFixed(2)} $_toUnit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: pastelPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Genera un Dropdown estilizado para seleccionar unidades con íconos sin repetir ningún código
  Widget _buildDropdown(String currentValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: pastelPrimary, width: 1.5),
      ),
      child: DropdownButton<String>(
        value: currentValue,
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: pastelPrimary),
        items: TemperatureUnits.units.map((unit) {
          return DropdownMenuItem(
            value: unit,
            child: Row(
              children: [
                Icon(unitIcons[unit] ?? Icons.help_outline,
                    color: pastelPrimary, size: 20),
                const SizedBox(width: 8),
                Text(unit),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
