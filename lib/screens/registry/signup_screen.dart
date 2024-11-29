import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishmastery/screens/registry/verify_email.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool agreePersonalData = false;
  final _formSignupKey = GlobalKey<FormState>();

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
                      child: Form(
                        key: _formSignupKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _fullNameController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Full Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Full Name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: agreePersonalData,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      agreePersonalData = value!;
                                    });
                                  },
                                  activeColor: Colors.white,
                                  checkColor: Colors.black,
                                ),
                                const Expanded(
                                  child: Text(
                                    'I agree to the processing of Personal data',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formSignupKey.currentState!.validate()) {
                                  if (agreePersonalData) {
                                    try {
                                      final email = _emailController.text;
                                      final password = _passwordController.text;

                                      // Create user with Firebase Auth
                                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );

                                      // Get the user and add their info to Firestore
                                      final user = userCredential.user;
                                      await FirebaseFirestore.instance.collection("Users").doc(user!.uid).set({
                                        'email': email,
                                        'FullName': _fullNameController.text,
                                        'Level' :'high',
                                      });

                                      // Send verification email
                                      await user.sendEmailVerification();

                                      // Navigate to the verification page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const VerifyEmailView(),
                                        ),
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      // Handle errors
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Sign Up Error'),
                                          content: Text(e.message ?? 'Unknown error'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const AlertDialog(
                                        title: Text('Agreement Required'),
                                        content: Text('You must agree to the processing of Personal data.'),
                                        actions: [
                                          TextButton(
                                            onPressed: null,
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Already have an account? Sign In',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
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
