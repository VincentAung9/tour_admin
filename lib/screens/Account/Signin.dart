import 'dart:developer';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/UserRole.dart';
import '../Bottom_Nav_Bar.dart';
import 'Create_Account.dart';
import '../../models/User.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isSignedIn = false;

  late AnimationController _controller;
  late Animation<double> _cloudAnimation;
  late Animation<double> _iconAnimation;
  late Animation<double> _sunAnimation; // Added for sun animation

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _cloudAnimation = Tween<double>(begin: -40, end: 40).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _sunAnimation = Tween<double>(begin: 40, end: 48).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      setState(() => _isSignedIn = session.isSignedIn);
    } catch (e) {
      safePrint('Auth check failed: $e');
    }
  }

  Future<void> _checkAndCreateUserProfileIfNeeded() async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      final userId = authUser.userId;
      final request = ModelQueries.get(
        User.classType,
        UserModelIdentifier(id: userId),
      );
      final response = await Amplify.API.query(request: request).response;
      var exists = !(response.data == null);
      if (!exists) {
        final attributes = await Amplify.Auth.fetchUserAttributes();
        final newUser = User(
          id: userId,
          name: attributes[5].value,
          email: attributes[0].value,
          phone: attributes[2].value,
          nickname: attributes[4].value,
          profile: attributes[6].value,
          role: UserRole.USER,
        );
        log("New User: $newUser");
        final request = ModelMutations.create(newUser);
        final response = await Amplify.API.mutate(request: request).response;

        if (response.errors.isNotEmpty) {
          safePrint('❌ GraphQL errors: ${response.errors}');
        } else {
          safePrint('✅ User profile created via API');
        }
        log("🔥 Create Data: ${response.data}");
        debugPrint("User profile created for ID: $userId");
      }
    } catch (e) {
      safePrint('Error checking/creating user profile: $e');
    }
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final session = await Amplify.Auth.fetchAuthSession();
        if (session.isSignedIn) {
          await Amplify.Auth.signOut();
        }

        final result = await Amplify.Auth.signIn(
          username: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (result.isSignedIn && mounted) {
          await _checkAndCreateUserProfileIfNeeded();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
                content: Text('Signed in successfully!')),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigation()),
                (Route<dynamic> route) => false,
          );
        }
      } on AuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-in failed: ${e.message}')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Stack(
        children: [
          // Back button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Back',
              ),
            ),
          ),
          // Animated clouds background
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) {
              return Positioned(
                top: 170 + _cloudAnimation.value,
                left: 30,
                child: const Opacity(
                  opacity: 0.7,
                  child: Icon(Icons.cloud, size: 80, color: Colors.white),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) {
              return Positioned(
                top: 120 - _cloudAnimation.value,
                right: 40,
                child: const Opacity(
                  opacity: 0.5,
                  child: Icon(Icons.cloud, size: 60, color: Colors.white),
                ),
              );
            },
          ),
          // Animated Sun
          AnimatedBuilder(
            animation: _sunAnimation,
            builder: (context, child) {
              return Positioned(
                top: 100,
                left: MediaQuery.of(context).size.width / 5,
                child: Container(
                  width: _sunAnimation.value,
                  height: _sunAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF176), Color(0xFFFFA726)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: _sunAnimation.value * 0.5,
                        spreadRadius: _sunAnimation.value * 0.125,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _iconAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, (1 - _iconAnimation.value) * 40),
                              child: Opacity(
                                opacity: _iconAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent.withOpacity(0.2),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.airplanemode_active,
                                    size: 100,
                                    color: Color(0xFF1976D2),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          'Avantour Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                            fontFamily: 'Arial',
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Email and Password fields
                        Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.email, color: Color(0xFF1976D2)),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.lock, color: Color(0xFF1976D2)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: const Color(0xFF1976D2),
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password reset not implemented')),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Color(0xFF1976D2)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedBuilder(
                          animation: _iconAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 0.95 + 0.05 * _iconAnimation.value,
                              child: child,
                            );
                          },
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                              shadowColor: Colors.blueAccent,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Login',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateAccountView(),
                              ),
                            );
                          },
                          child: const Text(
                            "Don't have an account? Sign Up",
                            style: TextStyle(color: Color(0xFF1976D2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}