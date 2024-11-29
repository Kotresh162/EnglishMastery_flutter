import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishmastery/screens/dashboard_screen.dart';
import 'package:englishmastery/screens/profille_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../courses/courses_screen.dart';
import '../registry/signin_screen.dart';

// Function to show the logout confirmation dialog
Future<bool> ShowlogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel logout
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Proceed with logout
            },
            child: const Text('Log Out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false); // Default to false if value is null
}

// Reusable widget for displaying the profile picture and name
class ProfileWidget extends StatelessWidget {
  final String name;
  final String photoUrl;
  final VoidCallback onTap;

  const ProfileWidget({
    super.key,
    required this.name,
    required this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50, // Profile picture size
            backgroundImage: NetworkImage(photoUrl),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Fetch user data from Firestore using email
Future<Map<String, dynamic>> getUserData() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUser.email)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = userSnapshot.docs.first;
      return userDoc.data() as Map<String, dynamic>;
    }
  }
  return {};
}

// Custom Drawer with navigation options
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loader while data is being fetched
                }

                if (snapshot.hasError) {
                  return const Text("Error fetching data");
                }

                if (snapshot.hasData) {
                  var userData = snapshot.data!;
                  String name = userData['FullName'] ?? 'User Name';  // Default if data is missing
                  String photoUrl = userData['photo'] ?? 'https://example.com/default_photo.jpg'; // Default photo

                  return ProfileWidget(
                    name: name,
                    photoUrl: photoUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                  );
                }

                return const Text('No data available');
              },
            ),
          ),
          const Divider(),

          // Drawer Menu Options
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Explore'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GraphicDesignScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('My Events'),
            onTap: () {
              Navigator.pushNamed(context, '/my_events');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // uploadQuestionsToFirebase();
              // Navigator.pushNamed(context, '/settings');
            },
          ),
          const Spacer(),

          // Logout Option
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final shouldOut = await ShowlogOutDialog(context);
              if (shouldOut) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
