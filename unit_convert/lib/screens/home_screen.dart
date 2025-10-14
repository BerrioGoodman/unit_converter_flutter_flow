import 'package:flutter/material.dart';
import 'length_converter_screen.dart';
import 'weight_converter_screen.dart';
import 'temperature_converter_screen.dart';
import 'currency_converter_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';

//Es stateful porque cambia constantemente la pantalla al seleccionar una pestaña
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; //pestaña seleccionada actualmente

  // Lista de pantallas para cada pestaña
  final List<Widget> _screens = [
    LengthConverterScreen(),
    WeightConverterScreen(),
    TemperatureConverterScreen(),
    CurrencyConverterScreen(),
    HistoryScreen(),
  ];

  // Cambia la pestaña seleccionada cuando el usuario toca un ícono
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
        backgroundColor: const Color(0xFFA3C9A8),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.straighten),
            label: 'Longitud',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight),
            label: 'Peso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Temperatura',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Moneda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2E7D32), // Dark green for selected
        unselectedItemColor: const Color(0xFF6D6D6D), // Medium gray for unselected
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        onTap: _onItemTapped,
      ),
    );
  }
}