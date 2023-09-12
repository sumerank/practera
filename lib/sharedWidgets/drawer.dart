import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../configs/config.dart';
import '../http/AuthService.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  static int _selectedIndex = 0;
  late final TextStyle optionStyle;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if ((AuthService.authUser['role'] == 1 && index == 6) ||
        (AuthService.authUser['role'] == 0 && index == 5)) {
      AuthService().logout().then((res) => {
            if (res) Navigator.of(context).pushNamed(icons[index]['route'])

            //  Navigator.of(context).pushNamed(icons[index]['route'])
          });
    } else {
      Navigator.of(context).pushNamed(icons[index]['route']);
    }
  }

  late List<Map<String, dynamic>> icons;

  @override
  void initState() {
    super.initState();
    optionStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    setState(() {
      icons = _buildIconsList();
    });
  }

  late final List<Widget> _widgetOptions;

  int? role = AuthService.authUser['role'] ?? 0;

  Future<void> _checkRoleAndNavigate() async {
    if ((AuthService.authUser['role'] ?? 0) == 1) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/donations',
        (route) => false,
      );
    }
  }

  List<Map<String, dynamic>> _buildIconsList() {
    return [
      {'ic': Icons.home, 'name': 'Home', 'route': '/home'},
      {'ic': Icons.category, 'name': 'What We Do', 'route': '/whatwedo'},
      {'ic': Icons.share, 'name': 'Referal', 'route': '/referal'},
      {'ic': Icons.favorite, 'name': 'Donation', 'route': '/donateus'},
      {'ic': Icons.contact_page, 'name': 'Contact Us', 'route': '/contactus'},
      if (AuthService.authUser['role'] == 1)
        {
          'ic': Icons.stacked_line_chart_rounded,
          'name': 'Statistics',
          'route': '/statistics'
        },
      if (AuthService.token != '')
        {'ic': Icons.logout_outlined, 'name': 'Log Out', 'route': '/login'},
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _widgetOptions = <Widget>[
      for (int i = 0; i < icons.length; i++)
        Row(
          children: [
            Icon(
              icons[i]['ic'],
            ),
            const SizedBox(width: 10),
            Text(
              icons[i]['name'],
              style: optionStyle,
            ),
          ],
        ),
    ];
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Config.primaryColor,
            ),
            child: const SizedBox(
              width: 100,
              height: 100,
              child: Image(image: AssetImage('assets/images/logo.png')),
            ),
          ),
          for (int i = 0; i < _widgetOptions.length; i++)
            ListTile(
              title: _widgetOptions[i],
              selected: _selectedIndex == i,
              onTap: () {
                _selectedIndex = i;
                _onItemTapped(i);
              },
            ),
        ],
      ),
    );
  }
}
