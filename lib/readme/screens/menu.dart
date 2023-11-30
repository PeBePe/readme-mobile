import 'package:flutter/material.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:readme_mobile/readme/widgets/menu_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final List<MenuItem> menuItems = [
    MenuItem("Shop", Icons.shopping_bag_outlined, Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Readme',
          ),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'H3LL0 PBP AO3',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: menuItems.map((MenuItem menuItem) {
                  // Iterasi untuk setiap MenuItem
                  return MenuCard(menuItem);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      drawer: const LeftDrawer(),
    );
  }
}

class MenuItem {
  final String name;
  final IconData icon;
  final Color color;

  MenuItem(this.name, this.icon, this.color);
}
