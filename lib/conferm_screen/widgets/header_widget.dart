import 'package:flutter/material.dart';

import '../../notification.dart';
import '../../profile.dart';
import 'search_bar_widget.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: const BoxDecoration(
        color: Color(0xFF8BE0C1),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage())),
            icon: const Icon(Icons.notifications),
            color: Colors.white,
          ),
          const SearchBarWidget(),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
            icon: const Icon(Icons.person),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
