import 'package:findmyadvocate/controller/auth_controller.dart';
import 'package:findmyadvocate/views/drawer_pages/about.dart';
import 'package:findmyadvocate/views/search_advocate.dart';
import 'package:findmyadvocate/views/settings_page.dart';
import 'package:findmyadvocate/views/user_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final AuthController _authController = Get.find<AuthController>();

  static final List<Widget> _pages = [
    HomePage(),
    SearchAdvocateScreen(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = _authController.user?.email ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('LegalLink'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 2; // Navigate to Settings Page
                });
              },
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  userEmail.isNotEmpty ? userEmail[0].toUpperCase() : "?",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(''),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child:Icon(Icons.person)
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                Get.to(AboutPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () {
                
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share App'),
              onTap: () {
                Get.snackbar("Share", "App share functionality coming soon!");
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Rate App'),
              onTap: () {
                Get.snackbar("Rate", "Rate functionality coming soon!");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _authController.logout();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            color: Colors.grey[800],
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.blue,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
