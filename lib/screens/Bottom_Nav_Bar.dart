// main_navigation.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tour_agent_aws/Admin/TourList_to_Edit.dart';
import 'package:tour_agent_aws/models/Country.dart';
import '../Admin/admin_Booking_List.dart';
import '../Admin/promo_mgmt.dart';
import 'Account/Create_Account.dart';
import 'Account/ProfilePage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    //TourFormScreen(),
    TourListScreen(),
    AdminBookingScreen(),

    /*  HomeScreen(),
    UserBookingScreen(), */
    AdminPromoManager(),
    ProfilePage(),
    // ChatUserListScreen(),

    // SignInScreen(),

    //CreateAccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 👈 force consistent look
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          /*  BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Home',
          ), */
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.discount),
            label: 'Promo Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.admin_panel_settings),
          //   label: 'Chat',
          // ),
        ],
      ),
    );
  }
}
