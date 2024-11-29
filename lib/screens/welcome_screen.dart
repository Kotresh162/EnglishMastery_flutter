import 'package:flutter/material.dart';
import 'registry/signin_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Column(
                    children: [
                      Text(
                        'Welcome to Interactive English Mastery',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Master English with ease and fun!',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 16.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: Theme.of(context).primaryColor, // Updated from 'primary'
                        ),
                        child: Text(
                          'Get Started',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(), // This empty SizedBox replaces the "Already have an account" line
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
