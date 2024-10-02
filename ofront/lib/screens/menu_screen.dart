import 'package:epik/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Contenu du Menu 1')),
    Center(child: Text('Contenu du Menu 2')),
    Center(child: Text('Contenu du Menu 3')),
  ];

  final List<String> menu = [
    'Ajouter',
    'Liste des élèves',
    'Paramètre prix',
    'Solde',
    'Service client'
  ];

  @override
  void initState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedIndex = prefs.getInt('page') == null ? 0 : prefs.getInt('page')!;
    super.initState();
  }

  void _onMenuItemSelected(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = index;
      prefs.setInt('page', _selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0, // Largeur du volet de gauche
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/logo.png',
                width: 150), // Remplace par le chemin de ton logo
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text('KONE Aziz Rodrigue'),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: MenuWidget(
              menuItems: menu,
              selectedIndex: _selectedIndex,
              onMenuItemSelected: _onMenuItemSelected,
            ),
          ),
        ],
      ),
    );
  }
}
