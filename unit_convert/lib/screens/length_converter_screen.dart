import 'package:flutter/material.dart';
import '../../services/conversion_service.dart';
import '../models/conversion_rates.dart';

class LengthConverterScreen extends StatefulWidget
{
  @override
  _LengthConverterScreenState createState() => _LengthConverterScreenState();
}

class _LengthConverterScreenState extends State<LengthConverterScreen>
{
  final TextEditingController _controller = TextEditingController();
  String _fromUnit = 'Kilómetros';
  String _toUnit = "Metros";
  double? _result;

  void _convert() {
    double? input = double.tryParse(_controller.text);
    if (input != null) {
      setState(() {
        _result = ConversionService.convert(
          input,
          _fromUnit,
          _toUnit,
        );
      });
    } else {
      setState(() {
        _result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversor de Longitud')),
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
                  items: conversionRates.keys
                      .map((unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _fromUnit = value!;
                    });
                    _convert();
                  },
                ),
                Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: _toUnit,
                  items: conversionRates.keys
                      .map((unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _toUnit = value!;
                    });
                    _convert();
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              _result == null
                  ? 'Ingrese un número válido'
                  : 'Resultado: ${_result!.toStringAsFixed(2)} $_toUnit',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}