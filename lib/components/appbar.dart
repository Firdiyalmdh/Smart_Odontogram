import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(50.0);

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
          SizedBox(width: 8.0),
          Column(
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
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.blue[900],
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
