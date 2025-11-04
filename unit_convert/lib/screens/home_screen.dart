import 'package:flutter/material.dart';
import 'length_converter_screen.dart';
import 'weight_converter_screen.dart';
import 'temperature_converter_screen.dart';
import 'currency_converter_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';
import '../models/user.dart';

//Es stateful porque cambia constantemente la pantalla al seleccionar una pestaña
class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; //pestaña seleccionada actualmente

  // Lista de pantallas para cada pestaña
  late final List<Widget> _screens;

  // Cambia la pestaña seleccionada cuando el usuario toca un ícono
  @override
  void initState() {
    super.initState();
    _screens = [
      LengthConverterScreen(user: widget.user),
      WeightConverterScreen(),
      TemperatureConverterScreen(),
      CurrencyConverterScreen(user: widget.user),
      HistoryScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToProfile() async {
    final updatedUser = await Navigator.of(context).push<User>(
      MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.user)),
    );

    if (updatedUser != null) {
      // Update the user if it was modified
      setState(() {
        // Since User is immutable, we need to create a new HomeScreen or handle differently
        // For now, we'll just update the reference if needed
      });
    }
  }

  void _navigateToAdmin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AdminScreen()),
    );
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
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => _navigateToAdmin(),
            tooltip: 'Panel Admin',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _navigateToProfile(),
            tooltip: 'Perfil',
          ),
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