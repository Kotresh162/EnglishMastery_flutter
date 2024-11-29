import 'package:flutter/material.dart';
import 'test_page.dart'; // Import the Test Page

class GrammarHomePage extends StatefulWidget {
  const GrammarHomePage({super.key});

  @override
  _GrammarHomePageState createState() => _GrammarHomePageState();
}

class _GrammarHomePageState extends State<GrammarHomePage> {
  bool showMixedTopicsTest = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Grammar', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back press
          },
        ),
        backgroundColor: const Color(0xFF0D1B2A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Tab Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton('TOPIC', !showMixedTopicsTest, () {
                  setState(() {
                    showMixedTopicsTest = false;
                  });
                }),
                _buildTabButton('MIXED TOPICS TEST', showMixedTopicsTest, () {
                  setState(() {
                    showMixedTopicsTest = true;
                  });
                }),
              ],
            ),
            const SizedBox(height: 20),
            // Conditional content based on the selected tab
            showMixedTopicsTest ? _buildMixedTopicsTestContent() : _buildTopicContent(),
          ],
        ),
      ),
    );
  }

  // Function to build the tabs
  Widget _buildTabButton(String title, bool isSelected, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007BFF) : const Color(0xFF1B263B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF007BFF),
            width: 2,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF007BFF),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Content for "MIXED TOPICS TEST" tab
  Widget _buildMixedTopicsTestContent() {
    return Expanded(
      child: ListView(
        children: [
          _buildTestCard('CUSTOM TEST', const Color(0xFF007BFF), const Color(0xFF1B263B), () {
            // Navigate to Custom Test
          }),
          _buildTestCard('BEGINNER TEST', const Color(0xFFFFA500), const Color(0xFFFF6347), () {
            // Navigate to Beginner Test
          }),
          _buildTestCard('MEDIUM TEST', const Color(0xFF32CD32), const Color(0xFFFFFF00), () {
            // Navigate to Medium Test
          }),
          _buildTestCard('ADVANCED TEST', const Color(0xFF007BFF), const Color(0xFF1B263B), () {
            // Navigate to Advanced Test
          }),
        ],
      ),
    );
  }

  // Content for "TOPIC" tab
  Widget _buildTopicContent() {
    return Expanded(
      child: ListView(
        children: [
          _buildTopicCard('1. Noun', 'Test'),
          _buildTopicCard('2. Pronoun', 'Test'),
          _buildTopicCard('3. Verb', 'Test'),
          _buildTopicCard('4. Adverb', 'Test'),
          _buildTopicCard('5. Tenses', 'Test'),
        ],
      ),
    );
  }

  // Function to build each test card for "MIXED TOPICS TEST" tab
  Widget _buildTestCard(String title, Color startColor, Color endColor, VoidCallback onStart) {
    return GestureDetector(
      onTap: onStart,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF1B263B),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('START'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build each topic card for "TOPIC" tab
  Widget _buildTopicCard(String title, String testLabel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF1B263B),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Test Page when "Test" button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TestPage()),
                    );
                  },
                  child: Text(testLabel.toUpperCase()),
                ),
              ],
            ),
          ],
        ),
      ), // Match the card background to the theme
    );
  }
}
