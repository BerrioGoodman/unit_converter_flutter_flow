import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, dynamic>> _allConversions = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  // Colores de la pantalla
  final Color pastelBackground = const Color(0xFFF8F1F1);
  final Color pastelPrimary = const Color(0xFFA3C9A8);
  final Color pastelAccent = const Color(0xFFFFE4B5);
  final Color pastelSecondary = const Color(0xFFE8D5C4);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final conversions = await DatabaseHelper.instance.getAllConversionsWithUsers();
      final stats = await DatabaseHelper.instance.getConversionStatsByUser();

      setState(() {
        _allConversions = conversions;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'length':
        return 'Longitud';
      case 'weight':
        return 'Peso';
      case 'temperature':
        return 'Temperatura';
      case 'currency':
        return 'Moneda';
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
      case 'currency':
        return Icons.attach_money;
      default:
        return Icons.history;
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''} atrás';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
      } else {
        return 'Ahora mismo';
      }
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: pastelBackground,
        appBar: AppBar(
          title: const Text(
            'Panel Administrativo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: pastelPrimary,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Todas las Conversiones'),
              Tab(text: 'Estadísticas'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadData,
              tooltip: 'Actualizar datos',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildConversionsTab(),
                  _buildStatsTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildConversionsTab() {
    if (_allConversions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings,
              size: 80,
              color: pastelPrimary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay conversiones registradas',
              style: TextStyle(
                fontSize: 18,
                color: pastelPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _allConversions.length,
        itemBuilder: (context, index) {
          final conversion = _allConversions[index];
          return Card(
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: pastelPrimary.withOpacity(0.1),
                        child: Icon(
                          _getTypeIcon(conversion['type']),
                          color: pastelPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Usuario: ${conversion['username']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: pastelPrimary,
                              ),
                            ),
                            Text(
                              _getTypeDisplayName(conversion['type']),
                              style: TextStyle(
                                color: pastelAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: pastelSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${conversion['input_value']} ${conversion['from_unit']} → ${conversion['result']} ${conversion['to_unit']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(conversion['timestamp']),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsTab() {
    final userStats = _stats['userStats'] as List<Map<String, dynamic>>? ?? [];
    final totalUsers = _stats['totalUsers'] as int? ?? 0;
    final totalConversions = _stats['totalConversions'] as int? ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estadísticas generales
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Estadísticas Generales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: pastelPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Total Usuarios', totalUsers.toString(), Icons.people),
                      _buildStatItem('Total Conversiones', totalConversions.toString(), Icons.calculate),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Estadísticas por usuario
          Text(
            'Actividad por Usuario',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: pastelPrimary,
            ),
          ),
          const SizedBox(height: 12),

          if (userStats.isEmpty)
            Center(
              child: Text(
                'No hay datos de usuarios',
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userStats.length,
              itemBuilder: (context, index) {
                final user = userStats[index];
                final username = user['username'] as String;
                final totalConversions = user['total_conversions'] as int;
                final conversionTypes = user['conversion_types'] as String?;

                return Card(
                  color: Colors.white,
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: pastelPrimary.withOpacity(0.1),
                      child: Text(
                        username[0].toUpperCase(),
                        style: TextStyle(
                          color: pastelPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '$totalConversions conversiones\nTipos: ${conversionTypes ?? 'Ninguno'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: pastelPrimary, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: pastelPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}