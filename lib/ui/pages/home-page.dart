import 'package:amber_bird/ui/widget/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0; // to keep track of active tab index
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RouterOutlet(),
      bottomNavigationBar: BottomNav(
        index: currentTab,
        backgroundColor: Colors.white,
        showElevation: true,
        navBarHeight: 75.0,
        radius: 30.0,
        onTap: (i) {
          setState(() {
            currentTab = i;
            switch (currentTab) {
              case 0:
                Modular.to.navigate('/main');
                break;
              case 1:
                Modular.to.navigate('/category');
                break;
              case 2:
                Modular.to.navigate('/cart');
                break;
              case 3:
                Modular.to.navigate('/login');
                break;
            }
          });
        },
        items: [
          BottomNavItem(
              imgIcon:
                  'https://cdn2.sbazar.app/383ba026-222a-4a16-8c24-b6f7f7227630',
              icon: Icons.home,
              label: "Home",
              selectedColor: Colors.red.shade900),
          BottomNavItem(
              icon: Icons.category,
              label: "Category",
              selectedColor: Colors.green),
          BottomNavItem(
              icon: Icons.shopping_bag,
              label: "Search",
              selectedColor: Colors.amber.shade800),
          BottomNavItem(
              icon: Icons.account_circle,
              label: "Profile",
              selectedColor: Colors.blue),
        ],
      ),
    );
  }
}
