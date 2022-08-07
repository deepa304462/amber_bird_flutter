import 'package:amber_bird/ui/widget/bottom_nav.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' as routerOut;
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

PreferredSize _appBar(address) {
  var dropdownvalue;
  return PreferredSize(
    preferredSize: const Size.fromHeight(100),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.lightGrey),
              child: Row(children: [
                IconButton(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                  icon: const Icon(Icons.location_city, color: Colors.black),
                ),
                Text(address != '' ? address.substring(0, 20) : 'Location')
              ]),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.lightGrey),
              child: IconButton(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(Icons.shopping_basket, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0; // to keep track of active tab index
  RxString address = ''.obs;
  @override
  initState() {
    getLocation();
    super.initState();
  }

  getLocation() async {
    String ad = (await SharedData.read('current-address')).toString();
    address.value = ad;
    setState(() {
      address = address;
    });
    changeTab(currentTab);
    // print('jjjjjjjjjjjjj${address.toString()}');
  }
  changeTab(currentTab){
    switch (currentTab) {
      case 0:
        routerOut.Modular.to.navigate('/main');
        break;
      case 1:
        routerOut.Modular.to.navigate('/category');
        break;
      case 2:
        routerOut.Modular.to.navigate('/cart');
        break;
      case 3:
        routerOut.Modular.to.navigate('/login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.lightGrey),
                  child: Row(children: [
                    IconButton(
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon:
                          const Icon(Icons.location_city, color: Colors.black),
                    ),
                    Text(address.toString() != ''
                        ? address.toString().substring(0, 20)
                        : 'Location')
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.lightGrey),
                  child: IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                    icon:
                        const Icon(Icons.shopping_basket, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: const routerOut.RouterOutlet(),
      bottomNavigationBar: BottomNav(
        index: currentTab,
        backgroundColor: Colors.white,
        showElevation: true,
        navBarHeight: 75.0,
        radius: 30.0,
        onTap: (i) {
          setState(() {
            currentTab = i;
            changeTab(currentTab);
            
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
