import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'product_create_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  final String username;
  final int userId;

  const HomeScreen({Key? key, required this.token, required this.username, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Lista de las pantallas para cada opción del menú
    _widgetOptions = <Widget>[
      ProductListScreen(token: widget.token),
      ProductCreateScreen(token: widget.token),
      ChatScreen(username: widget.username, token: widget.token, userId: widget.userId),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Listar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Crear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green, // Color adaptado a 'EcoHome'
        onTap: _onItemTapped,
      ),
    );
  }
}