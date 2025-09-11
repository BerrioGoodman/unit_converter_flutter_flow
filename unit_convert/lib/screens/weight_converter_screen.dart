import 'package:flutter/material.dart';
import '../models/weight_units.dart';
import '../services/conversion_service.dart';

class WeightConverterScreen extends StatefulWidget {
  @override
  _WeightConverterScreenState createState() => _WeightConverterScreenState();
}

class _WeightConverterScreenState extends State<WeightConverterScreen> {
  final TextEditingController _controller = TextEditingController();
  String _fromUnit = 'Kilogramos';
  String _toUnit = 'Libras';
  double? _result;
  String? _error;

  void _convert() {
    double? input = double.tryParse(_controller.text);

    if (input == null) {
      setState(() {
        _result = null;
        _error = "Ingrese un número válido";
      });
      return;
    }

    double? converted = ConversionService.convert(
        input, _fromUnit, _toUnit, WeightUnits.conversionRates);

    setState(() {
      if (converted == null) {
        _result = null;
        _error = "El valor no puede ser negativo";
      } else {
        _result = converted;
        _error = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conversor de Peso")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ingrese un valor',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _convert(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: _fromUnit,
                  items: WeightUnits.conversionRates.keys
                      .map((unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _fromUnit = value!);
                    _convert();
                  },
                ),
                Icon(Icons.swap_horiz),
                DropdownButton<String>(
                  value: _toUnit,
                  items: WeightUnits.conversionRates.keys
                      .map((unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _toUnit = value!);
                    _convert();
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
            else if (_result != null)
              Text(
                'Resultado: ${_result!.toStringAsFixed(2)} $_toUnit',
                style: TextStyle(fontSize: 20),
              )
            else
              Text('Ingrese un valor para convertir'),
          ],
        ),
      ),
    );
  }
}
