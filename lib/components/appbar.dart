import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() onLogoutClick;

  const MyAppBar({super.key, required this.onLogoutClick});

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'assets/logoblue.png',
            width: 40.0,
            height: 40.0,
          ),
          const SizedBox(width: 8.0),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 8.0),
              Text(
                'Selamat datang,',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
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
