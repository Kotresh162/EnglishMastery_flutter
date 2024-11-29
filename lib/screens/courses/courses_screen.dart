import 'package:englishmastery/screens/courses/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GraphicDesignScreen extends StatelessWidget {
  const GraphicDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back press
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suggested Videos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildFeaturedCourses(context),
              SizedBox(height: 24),
              Text(
                'All Courses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildAllCourses(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCourses(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Videos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No videos found');
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              String title = data['title'] ?? 'No Title';  // Default value for title
              String youtubeUrl = data['youtubelink'] ?? '';  // Default empty string if no link
              double rating = data.containsKey('rating') ? data['rating'].toDouble() : 0.0; // Safe access for rating

              if (youtubeUrl.isEmpty) {
                return const SizedBox.shrink(); // Skip if no YouTube URL is available
              }

              return _buildCourseCard(
                context: context,
                youtubeUrl: youtubeUrl,
                title: title,
                rating: rating,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoScreen(youtubeUrl: youtubeUrl),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildAllCourses(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Videos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No videos found');
        }

        return Column(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            String title = data['title'] ?? 'No Title';  // Default value for title
            String youtubeUrl = data['youtubelink'] ?? '';  // Default empty string if no link
            double rating = data.containsKey('rating') ? data['rating'].toDouble() : 0.0; // Safe access for rating

            if (youtubeUrl.isEmpty) {
              return const SizedBox.shrink(); // Skip if no YouTube URL is available
            }

            return _buildCourseItem(
              context: context,
              imageUrl: 'https://img.youtube.com/vi/${_getVideoId(youtubeUrl)}/0.jpg', // Updated to use youtubelink for thumbnail
              title: title,
              rating: rating,
              lessons: '15 Lessons',
              duration: '30 Hrs',
            );
          }).toList(),
        );
      },
    );
  }

  // Function to extract the YouTube video ID
  String _getVideoId(String youtubeUrl) {
    final Uri uri = Uri.parse(youtubeUrl);
    return uri.queryParameters['v'] ?? uri.pathSegments.last;
  }

  Widget _buildCourseCard({
    required BuildContext context,
    required String youtubeUrl,
    required String title,
    required double rating,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  'https://img.youtube.com/vi/${_getVideoId(youtubeUrl)}/0.jpg', // Updated to use youtubelink for thumbnail
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseItem({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required double rating,
    required String lessons,
    required String duration,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(lessons),
                  Text(duration),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
