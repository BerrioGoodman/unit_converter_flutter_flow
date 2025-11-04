import 'package:flutter/material.dart';
import '../models/currency_units.dart';
import '../services/currency_service.dart';
import '../models/exchange_rates.dart';
import '../models/conversion_history.dart';
import '../services/preferences_service.dart';
import '../services/database_helper.dart';
import '../models/user.dart';

class CurrencyConverterScreen extends StatefulWidget {
  final User? user; // Usuario actual para guardar conversiones en BD

  const CurrencyConverterScreen({Key? key, this.user}) : super(key: key);

  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _controller = TextEditingController();
  String _fromUnit = 'USD';
  String _toUnit = 'EUR';
  double? _result;
  String? _error;
  bool _isLoading = false;
  ExchangeRates? _exchangeRates;

  // colores de la pantalla
  final Color pastelBackground = const Color(0xFFF8F1F1);
  final Color pastelPrimary = const Color(0xFFA3C9A8);
  final Color pastelAccent = const Color(0xFFFFDAB9);

  // Íconos por unidad
  final Map<String, IconData> currencyIcons = {
    'USD': Icons.attach_money,
    'EUR': Icons.euro,
    'GBP': Icons.currency_pound,
    'JPY': Icons.currency_yen,
    'CAD': Icons.currency_exchange,
    'AUD': Icons.currency_exchange,
    'CHF': Icons.currency_franc,
    'CNY': Icons.currency_yen,
    'COP': Icons.currency_exchange,
    'MXN': Icons.currency_exchange,
    'BRL': Icons.currency_exchange,
    'ARS': Icons.currency_exchange,
    'CLP': Icons.currency_exchange,
    'PEN': Icons.currency_exchange,
    'UYU': Icons.currency_exchange,
  };

  @override
  void initState() {
    super.initState();
    _loadExchangeRates();
  }

Future<void> _loadExchangeRates() async {
  setState(() {
    _isLoading = true;
    _error = null;
  });

  try {
    final rates = await CurrencyService.getCachedOrFetchRates();

    if (rates != null) {
      // Esto imprimirá el mapa de monedas y sus tasas en la consola
      print('Tasas de cambio recibidas de la API: ${rates.rates}');
    } else {
      print('No se recibieron tasas de la API.');
    }

    setState(() {
      _exchangeRates = rates;
      _isLoading = false;
      if (rates == null) {
        _error = 'Error al cargar las tasas de cambio';
      }
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
      _error = 'Error de conexión: $e';
    });
  }
}

  Future<void> _convert() async {
    if (_exchangeRates == null) {
      await _loadExchangeRates();
      if (_exchangeRates == null) {
        setState(() {
          _error = 'No se pudieron cargar las tasas de cambio';
        });
        return;
      }
    }

    double? input = double.tryParse(_controller.text);

    if (input == null || input <= 0) {
      setState(() {
        _result = null;
        _error = "Ingrese un valor válido mayor a 0";
      });
      return;
    }

    final result = CurrencyService.convertCurrency(input, _fromUnit, _toUnit, _exchangeRates!);

    setState(() {
      if (result == null) {
        _result = null;
        _error = "Error en la conversión";
      } else {
        _result = result;
        _error = null;

        // Guardar en historial si la conversión fue exitosa
        final conversion = ConversionHistory(
          type: 'currency',
          inputValue: input,
          fromUnit: _fromUnit,
          toUnit: _toUnit,
          result: result,
          timestamp: DateTime.now(),
        );

        // Guardar en SharedPreferences (historial general)
        PreferencesService.saveConversion(conversion);

        // Si hay usuario logueado, guardar también en base de datos
        if (widget.user != null && widget.user!.id != null) {
          try {
            await DatabaseHelper.instance.insertConversion(widget.user!.id!, conversion);
          } catch (e) {
            print('Error al guardar conversión en BD: $e');
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelBackground,
      appBar: AppBar(
        title: const Text(
          'Conversor de Moneda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: pastelPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExchangeRates,
            tooltip: 'Actualizar tasas',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indicador de carga o error de API
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_error != null && _exchangeRates == null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Container(),

            // Caja de texto
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Ingrese un valor',
                labelStyle: TextStyle(color: pastelPrimary),
                prefixIcon: Icon(Icons.attach_money, color: pastelPrimary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdowns alineados
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDropdown(_fromUnit, (value) {
                  setState(() => _fromUnit = value!);
                }),
                Icon(Icons.swap_horiz, color: pastelAccent, size: 28),
                _buildDropdown(_toUnit, (value) {
                  setState(() => _toUnit = value!);
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Botón de conversión
            ElevatedButton(
              onPressed: _convert,
              style: ElevatedButton.styleFrom(
                backgroundColor: pastelPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Hacer conversión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Resultado estilizado con fondo blanco y sombra
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _error != null
                      ? _error!
                      : _result != null
                          ? 'Resultado:\n${_result!.toStringAsFixed(2)} $_toUnit'
                          : 'Presione "Hacer conversión" para convertir',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _error != null ? Colors.red : pastelPrimary,
                  ),
                ),
              ),
            ),

            // Información de última actualización
            if (_exchangeRates != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Última actualización: ${_exchangeRates!.timestamp.toString().substring(0, 19)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Genera un Dropdown estilizado para seleccionar monedas con íconos
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
        items: CurrencyUnits.currencies.map((currency) {
          return DropdownMenuItem(
            value: currency,
            child: Row(
              children: [
                Icon(currencyIcons[currency] ?? Icons.attach_money,
                    color: pastelPrimary, size: 20),
                const SizedBox(width: 8),
                Text('${CurrencyUnits.currencySymbols[currency] ?? currency} ($currency)'),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}