import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ProfilePage that fetches user data from Firestore using email as the primary key
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Get the current user's email from Firebase Authentication
  final String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  // Fetch user data from Firestore based on the email
  Future<Map<String, dynamic>> fetchUserData() async {
    if (currentUserEmail.isEmpty) {
      return {}; // Return an empty map if the email is not available
    }

    // Query the Firestore Users collection using the email field
    QuerySnapshot userDocs = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUserEmail) // Query by email
        .get();

    if (userDocs.docs.isNotEmpty) {
      return userDocs.docs.first.data() as Map<String, dynamic>; // Return the first matching user document
    } else {
      return {}; // Return an empty map if no data is found
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // Ensure proper navigation back
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text(
            "Profile Page",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[900],
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error state
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // No data found state
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No user data found'));
            }

            // Extract the user data
            var userData = snapshot.data!;
            String name = userData['FullName'] ?? 'No Name';
            String photoUrl = userData['photo'] ?? ''; // Empty if no photo URL
            String bio = userData['bio'] ?? 'No bio available'; // Empty bio fallback

            return ListView(
              children: [
                const SizedBox(height: 50),
                // Profile picture (can be replaced with actual user image)
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                    child: photoUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 72,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                // User Email
                Text(
                  currentUserEmail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Username
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Bio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Learning Progress Section (Mock Data)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Learning Progress',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Progress Bar for Lessons Completed (Mock Data)
                      LinearProgressIndicator(
                        value: 0.6, // Replace with actual progress data
                        backgroundColor: Colors.grey[400],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      const SizedBox(height: 10),

                      // Text showing the number of lessons completed
                      const Text(
                        '12 of 20 lessons completed', // Replace with actual progress data
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
