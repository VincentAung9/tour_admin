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

class _VerificationPageState extends State<VerificationPage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthManager _authManager = AuthManager();

  String? _errorMessage;
  bool _isVerifying = false;

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isVerifying = true);

    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: widget.email,
        confirmationCode: _codeController.text.trim(),
      );

      if (result.isSignUpComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile created successfully! Please log in.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      } else {
        setState(() => _errorMessage = "Verification not complete. Try again.");
      }
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendCode() async {
    try {
      await Amplify.Auth.resendSignUpCode(username: widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code resent!')),
      );
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A verification code has been sent to:',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 6),
              Text(email,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Code is required' : null,
              ),
              const SizedBox(height: 20),
              _isVerifying
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.verified_user),
                      label: const Text('Verify'),
                      onPressed: _verify,
                    ),
              TextButton(
                onPressed: _resendCode,
                child: const Text('Resend Code'),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
