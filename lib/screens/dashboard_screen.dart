import 'package:englishmastery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'courses/courses_screen.dart';
import 'assesment/grammer_scrren.dart';
import 'translate_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Learning at your finger tips.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Discover Language Resources...',
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DashboardCard(
                          imagePath: 'assets/images/courses.png',
                          title: 'Courses',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GraphicDesignScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 60),
                        DashboardCard(
                          imagePath: 'assets/images/assessments.png',
                          title: 'Assessments',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GrammarHomePage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DashboardCard(
                          imagePath: 'assets/images/games.png',
                          title: 'Games',
                          onTap: () {
                            // Navigate to games screen
                          },
                        ),
                        const SizedBox(width: 60),
                        DashboardCard(
                          imagePath: 'assets/images/trans_image.png',
                          title: 'Translator',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LanguageTranslatingPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const ProgressCard(
                  percentage: 30,
                  level: 'Beginner',
                  locked: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isNavigating = false; // Tracks if navigation is in progress

    return GestureDetector(
      onTap: () {
        if (!isNavigating) {
          isNavigating = true; // Lock navigation
          onTap();
          Future.delayed(const Duration(milliseconds: 300), () {
            isNavigating = false; // Unlock navigation after delay
          });
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final int percentage;
  final String level;
  final bool locked;

  const ProgressCard({
    super.key,
    required this.percentage,
    required this.level,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage('assets/images/progress_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$percentage% completed.',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: percentage / 100,
                color: Colors.black,
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(height: 10),
              Text(
                level,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        if (locked)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              color: Colors.black.withOpacity(0.5),
              child: const Text(
                'LOCKED',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
