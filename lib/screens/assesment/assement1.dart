import 'package:flutter/material.dart';

// void main() {
//   runApp(EnglishGrammarApp());
// }

class EnglishGrammarApp extends StatelessWidget {
  const EnglishGrammarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home: const GrammarHomePage(),
    );
  }
}

class GrammarHomePage extends StatefulWidget {
  const GrammarHomePage({super.key});

  @override
  _GrammarHomePageState createState() => _GrammarHomePageState();
}

class _GrammarHomePageState extends State<GrammarHomePage> {
  bool showAllTests = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Grammar'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Tab Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton('TOPIC', !showAllTests, () {
                  setState(() {
                    showAllTests = false;
                  });
                }),
                _buildTabButton('ALL TEST', showAllTests, () {
                  setState(() {
                    showAllTests = true;
                  });
                }),
              ],
            ),
            const SizedBox(height: 20),
            // Conditional content based on the selected tab
            showAllTests ? _buildAllTestContent() : _buildTopicContent(),
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
          color: isSelected ? Colors.purple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.purple,
            width: 2,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.purple,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Content for "ALL TEST" tab
  Widget _buildAllTestContent() {
    return Expanded(
      child: ListView(
        children: [
          _buildTestCard('CUSTOM TEST', Colors.purple, Colors.blue, () {
            // Navigate to Custom Test
          }),
          _buildTestCard('BEGINNER TEST', Colors.orange, Colors.pink, () {
            // Navigate to Beginner Test
          }),
          _buildTestCard('ADVANCED TEST', Colors.purple, Colors.blue, () {
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
          _buildTopicCard('1. Nouns', 'Test'),
          _buildTopicCard('2. Subject and verb agreement', 'Test'),
          _buildTopicCard('3. The simple present tense', 'Test'),
          _buildTopicCard('4. The simple past tense', 'Test'),
        ],
      ),
    );
  }

  // Function to build each test card for "ALL TEST" tab
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
                  foregroundColor: Colors.purple, backgroundColor: Colors.white,
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
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildTestButton(testLabel),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to build Test Button for "TOPIC" tab
  Widget _buildTestButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}