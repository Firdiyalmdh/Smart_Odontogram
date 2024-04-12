import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/models/user.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Rx<User> user;
  final void Function() onLogoutClick;

  const HomeAppBar({
    super.key,
    required this.user,
    required this.onLogoutClick
  });

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logoblue.png',
            width: 40.0,
            height: 40.0,
          ),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Selamat datang,',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              Obx(() => Text(
                  user.value.name,
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.blue[900],
            ),
            onPressed: () {
              onLogoutClick();
            },
          ),
        ],
      ),
    );
  }
}
