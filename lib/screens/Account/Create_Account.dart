import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'auth_manager.dart';
import 'Verify_Code_Page.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;
  final RegExp emailRegexp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final AuthManager _authManager = AuthManager();

  bool isLoading = false;
  bool _obscurePassword = true; // Added for password visibility toggle
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> selectImage({required ImageSource imageSource}) async {
    try {
      final XFile? selectedFile = await _imagePicker.pickImage(source: imageSource);
      if (selectedFile != null) {
        setState(() {
          _imageFile = File(selectedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text('No image selected')),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text('Error: $e')),
        ),
      );
    }
  }

  Future<void> _createAccountAndNavigate() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Please fill in all required fields correctly.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (_imageFile == null) {
      Fluttertoast.showToast(
        msg: "Please select your Profile picture.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() => isLoading = true);

    final String email = _emailController.text.trim();
    String toastMessage = "Attempting to create account...";
    String? imageUrl;

    try {
      imageUrl = await _authManager.createNewUser(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _nicknameController.text.trim(),
        email: email,
        password: _passwordController.text,
        imageFile: _imageFile!,
      );

      if (imageUrl != null) {
        toastMessage = "Account created. Please verify your email.";

        final String nonNullImageUrl = imageUrl;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPage(
              email: email,
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              nickname: _nicknameController.text.trim(),
              imageFile: _imageFile!,
              imageUrl: nonNullImageUrl,
            ),
          ),
        );
      } else {
        toastMessage = _authManager.message;
      }
    } catch (e) {
      toastMessage = "An error occurred during account creation: $e";
      print("Error creating account: $e");
    } finally {
      setState(() => isLoading = false);
    }

    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: imageUrl != null ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
                        Container(
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
                          child: _imageFile == null
                              ? const Icon(
                            Icons.account_circle,
                            size: 100,
                            color: Color(0xFF1976D2),
                          )
                              : ClipOval(
                            child: Image.file(
                              _imageFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          selectImage(imageSource: ImageSource.camera);
                                        },
                                        icon: const Icon(Icons.camera, color: Color(0xFF1976D2)),
                                        label: const Text('Select from Camera', style: TextStyle(color: Color(0xFF1976D2))),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          selectImage(imageSource: ImageSource.gallery);
                                        },
                                        icon: const Icon(Icons.photo_library, color: Color(0xFF1976D2)),
                                        label: const Text('Select from Gallery', style: TextStyle(color: Color(0xFF1976D2))),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.photo, color: Color(0xFF1976D2)),
                          label: const Text('Select Profile Picture', style: TextStyle(color: Color(0xFF1976D2))),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Avantour Sign Up',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                            fontFamily: 'Arial',
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Form fields
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.person, color: Color(0xFF1976D2)),
                          ),
                          validator: (value) => value!.isEmpty ? 'Full Name is required!' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.email, color: Color(0xFF1976D2)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Email is required!';
                            if (!emailRegexp.hasMatch(value)) return 'Email is invalid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.phone, color: Color(0xFF1976D2)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Phone number is required!';
                            if (value.length < 7) return 'Enter a valid phone number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nicknameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: 'Bio',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.info, color: Color(0xFF1976D2)),
                          ),
                          validator: (value) => value!.isEmpty ? 'Your Bio is required!' : null,
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
                            if (value!.isEmpty) return 'Password is required!';
                            if (value.length < 8) return 'Password should be 8 characters or more';
                            return null;
                          },
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
                            onPressed: isLoading ? null : _createAccountAndNavigate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                              shadowColor: Colors.blueAccent,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Create Account',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                            Navigator.pop(context); // Navigate back to sign-in
                          },
                          child: const Text(
                            "Already have an account? Sign In",
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