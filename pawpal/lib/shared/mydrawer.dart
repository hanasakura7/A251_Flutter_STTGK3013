import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/shared/animated_route.dart';
import 'package:pawpal/views/donationhistoryscreen.dart';
import 'package:pawpal/views/loginscreen.dart';
import 'package:pawpal/views/mainscreen.dart';
import 'package:pawpal/views/allpetlistscreen.dart';
import 'package:pawpal/views/profilescreen.dart';
import 'package:pawpal/views/settingscreen.dart';
import 'package:pawpal/views/adoptionhistoryscreen.dart';
import 'package:pawpal/views/userpetscreen.dart';

class MyDrawer extends StatefulWidget {
  final User? user;
  const MyDrawer({super.key, this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(radius: 15, child: Text('A')),
            accountName: Text(widget.user?.userName ?? 'Guest'),
            accountEmail: Text(widget.user?.userEmail ?? 'Guest'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(MainScreen(user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text('Animals List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(AllPetScreen(user: widget.user)),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text('My Donation History'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              if (widget.user != null) {
                // Good practice to check first
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) =>
                        MyDonationsScreen(user: widget.user!), // Add the ! here
                  ),
                );
              } else {
                // Optional: redirect to login if user is somehow null
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_edu),
            title: const Text('Adoption History'),
            onTap: () {
              Navigator.pop(context);
              if (widget.user?.userId == '0' || widget.user == null) {
                _showLoginDialog();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => AdoptionHistoryScreen(user: widget.user!),
                  ),
                );
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: const Text('My Uploaded Pets'),
            onTap: () {
              Navigator.pop(context);
              if (widget.user != null && widget.user!.userId != '0') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => MyPetsScreen(user: widget.user!),
                  ),
                );
              } else {
                _showLoginDialog();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              if (widget.user?.userId == '0' || widget.user == null) {
                _showLoginDialog();
              } else {
                Navigator.push(
                  context,
                  AnimatedRoute.slideFromRight(
                    ProfileScreen(user: widget.user!),
                  ),
                );
              }
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(SettingScreen(user: widget.user)),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Logout', style: TextStyle(color: Colors.black)),
            onTap: () {
              _showLogoutDialog();
            },
          ),
          const Divider(color: Colors.grey),
          SizedBox(
            height: screenHeight / 3.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text("Version 0.1b", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.lock_outline, color: Color.fromARGB(255, 239, 210, 115)),
            SizedBox(width: 8),
            Text("Login Required"),
          ],
        ),
        content: const Text(
          "Please login to continue and access this feature.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 213, 185, 84),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(const LoginScreen()),
              );
            },
            child: const Text("Login", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                Navigator.pop(context); // Close dialog

                // 1. Clear SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs
                    .clear(); // This removes email, password, and rememberMe

                // 2. Redirect to LoginScreen and clear navigation history
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
