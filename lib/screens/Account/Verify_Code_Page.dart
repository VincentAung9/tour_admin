import 'dart:io';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'Signin.dart';
import 'auth_manager.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  final String name;
  final String phone;
  final String nickname;
  final File imageFile;
  final String imageUrl;

  const VerificationPage({
    Key? key,
    required this.email,
    required this.name,
    required this.phone,
    required this.nickname,
    required this.imageFile,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthManager _authManager = AuthManager();
  String? _errorMessage;
  bool _isVerifying = false;
  bool _isLoading = false;
  bool _obscureCode = true;

  late AnimationController _controller;
  late Animation<double> _cloudAnimation;
  late Animation<double> _iconAnimation;
  late Animation<double> _sunAnimation;

  @override
  void initState() {
    super.initState();
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
    _codeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isVerifying = true);

    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: widget.email,
        confirmationCode: _codeController.text.trim(),
      );

      if (result.isSignUpComplete && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully! Please log in.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      } else {
        setState(() => _errorMessage = "Verification not complete. Try again.");
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'An error occurred: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isLoading = true);
    try {
      await Amplify.Auth.resendSignUpCode(username: widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code resent!')),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'An error occurred: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
                                    Icons.verified_user,
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
                          'Avantour Verification',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                            fontFamily: 'Arial',
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'A verification code has been sent to:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1976D2)),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _codeController,
                          obscureText: _obscureCode,
                          decoration: InputDecoration(
                            labelText: 'Verification Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.code, color: Color(0xFF1976D2)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureCode ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFF1976D2),
                              ),
                              onPressed: () {
                                setState(() => _obscureCode = !_obscureCode);
                              },
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Please enter the verification code' : null,
                        ),
                        const SizedBox(height: 16),
                        if (_errorMessage != null) ...[
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                        ],
                        AnimatedBuilder(
                          animation: _iconAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 0.95 + 0.05 * _iconAnimation.value,
                              child: child,
                            );
                          },
                          child: ElevatedButton(
                            onPressed: _isVerifying ? null : _verify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                              shadowColor: Colors.blueAccent,
                            ),
                            child: _isVerifying
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Verify',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading ? null : _resendCode,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Color(0xFF1976D2))
                              : const Text(
                            'Resend Code',
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