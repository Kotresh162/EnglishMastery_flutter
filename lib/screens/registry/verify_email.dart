import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signin_screen.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text('please verify email sent to ur mail'),
          const Text("if you didn't get conformation mail press below button"),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Verify'),
          ),
          TextButton(onPressed: () async{
            await FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            );
          }, child: const Text('restart')),
        ],
      ),
    );
  }
}