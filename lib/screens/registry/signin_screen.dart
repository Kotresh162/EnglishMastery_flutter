import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';
import '../dashboard_screen.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    // Check if user is already logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // If the user is logged in and email is verified, navigate to the dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }

  Future<void> showErrorDialog(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Stack(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _password,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                final user =
                                    FirebaseAuth.instance.currentUser;
                                if (user?.emailVerified ?? false) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const DashboardScreen(),
                                    ),
                                  );
                                } else {
                                  // Handle unverified email case
                                  await showErrorDialog(context,
                                      'Please verify your email');
                                }
                              } on FirebaseAuthException catch (e) {
                                switch (e.code) {
                                  case 'user-not-found':
                                    await showErrorDialog(
                                        context, 'User not found');
                                    break;
                                  case 'wrong-password':
                                    await showErrorDialog(
                                        context, 'Wrong password');
                                    break;
                                  default:
                                    await showErrorDialog(context,
                                        'Invalid credentials');
                                    break;
                                }
                              } catch (e) {
                                await showErrorDialog(
                                    context, e.toString());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Don’t have an account? Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
