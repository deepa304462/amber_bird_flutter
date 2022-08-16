import 'package:amber_bird/controller/state-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  // ProfilePage({Key? key}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {

  final Controller cont = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
          onPressed: () async {
            cont.logout();
          },
          child: Text("Logout")),
    );
  }
}
