import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoScreen extends StatefulWidget {
  final String youtubeUrl; // Accept the YouTube URL as a parameter

  const VideoScreen({required this.youtubeUrl, super.key}); // Add required parameter in constructor

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  String transcription = ''; // Variable to hold the transcription text

  @override
  void initState() {
    super.initState();

    // Convert the provided YouTube URL to a video ID
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.youtubeUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Fetch transcription from your backend
    fetchTranscription(widget.youtubeUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to fetch transcription from the backend
  Future<void> fetchTranscription(String youtubeUrl) async {
    try {
      final response = await http.post(
        Uri.parse('http://your-backend-url/process-video'), // Update with your backend URL
        body: {'video_url': youtubeUrl}, // Send the URL as a parameter to the backend
      );

      if (response.statusCode == 200) {
        // Parse the transcription from the response
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          transcription = data['transcription'] ?? 'No transcription available';
        });
      } else {
        throw Exception('Failed to fetch transcription');
      }
    } catch (e) {
      setState(() {
        transcription = 'Error fetching transcription: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back press
          },
        ),
      ),
      body: Column(
        children: [
          // YouTube Player
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            onReady: () {
              print('Player is ready.');
            },
          ),
          // Transcription Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              transcription,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
