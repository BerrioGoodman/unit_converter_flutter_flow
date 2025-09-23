import 'package:flutter/material.dart';
import 'length_converter_screen.dart';
import 'weight_converter_screen.dart';
import 'temperature_converter_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    LengthConverterScreen(),
    WeightConverterScreen(),
    TemperatureConverterScreen(),
    HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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