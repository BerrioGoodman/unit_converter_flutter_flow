import 'package:flutter/material.dart';
import '../models/conversion_history.dart';
import '../services/preferences_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ConversionHistory> _history = [];

  // 🎨 Colores pastel
  final Color pastelBackground = const Color(0xFFF8F1F1);
  final Color pastelPrimary = const Color(0xFFA3C9A8);
  final Color pastelAccent = const Color(0xFFFFE4B5);

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await PreferencesService.getConversionHistory();
    setState(() {
      _history = history;
    });
  }

  Future<void> _clearHistory() async {
    await PreferencesService.clearHistory();
    setState(() {
      _history = [];
    });
  }

  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'length':
        return 'Longitud';
      case 'weight':
        return 'Peso';
      case 'temperature':
        return 'Temperatura';
      default:
        return type;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'length':
        return Icons.straighten;
      case 'weight':
        return Icons.monitor_weight;
      case 'temperature':
        return Icons.thermostat;
      default:
        return Icons.history;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelBackground,
      appBar: AppBar(
        title: const Text(
          'Historial de Conversiones',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: pastelPrimary,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Limpiar Historial'),
                    content: Text('¿Estás seguro de que quieres borrar todo el historial?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Borrar'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await _clearHistory();
                }
              },
            ),
        ],
      ),
      body: _history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: pastelPrimary.withOpacity(0.5),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay conversiones recientes',
                    style: TextStyle(
                      fontSize: 18,
                      color: pastelPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Realiza algunas conversiones para ver el historial',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadHistory,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final conversion = _history[index];
                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: pastelPrimary.withOpacity(0.1),
                        child: Icon(
                          _getTypeIcon(conversion.type),
                          color: pastelPrimary,
                        ),
                      ),
                      title: Text(
                        '${conversion.inputValue.toStringAsFixed(2)} ${conversion.fromUnit} → ${conversion.result.toStringAsFixed(2)} ${conversion.toUnit}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: pastelPrimary,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTypeDisplayName(conversion.type),
                            style: TextStyle(
                              color: pastelAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatTimestamp(conversion.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Ahora mismo';
    }
  }
}