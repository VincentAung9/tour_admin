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

class _CreateAccountViewState extends State<CreateAccountView> {
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

  Future<void> selectImage({required ImageSource imageSource}) async {
    try {
      final XFile? selectedFile =
          await _imagePicker.pickImage(source: imageSource);
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
// 1. Validate form and image first
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

// 2. Start loading
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

// ✅ Navigate to VerificationPage with imageUrl
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPage(
              email: email,
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              nickname: _nicknameController.text.trim(),
              imageFile: _imageFile!,
              imageUrl: nonNullImageUrl, // ✅ tell Dart “I know it’s not null”
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

// 4. Show feedback toast
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
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: _imageFile == null
                      ? const Icon(Icons.account_circle,
                          size: 100, color: Colors.grey)
                      : Image.file(_imageFile!,
                          width: 130, height: 130, fit: BoxFit.cover),
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
                              icon: const Icon(Icons.camera),
                              label: const Text('Select from Camera'),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                selectImage(imageSource: ImageSource.gallery);
                              },
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Select from Gallery'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.photo),
                label: const Text('Select Profile Picture'),
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(label: Text('Full Name')),
                validator: (value) =>
                    value!.isEmpty ? 'Full Name is required!' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(label: Text('Email')),
                validator: (value) {
                  if (value!.isEmpty) return 'Email is required!';
                  if (!emailRegexp.hasMatch(value)) return 'Email is invalid';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(label: Text('Phone Number')),
                validator: (value) {
                  if (value!.isEmpty) return 'Phone number is required!';
                  if (value.length < 7) return 'Enter a valid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nicknameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(label: Text('Bio')),
                validator: (value) =>
                    value!.isEmpty ? 'Your Bio is required!' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(label: Text('Password')),
                validator: (value) {
                  if (value!.isEmpty) return 'Password is required!';
                  if (value.length < 8)
                    return 'Password should be 8 characters or more';
                  return null;
                },
              ),
              const SizedBox(height: 25),
              isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : TextButton(
                      onPressed: _createAccountAndNavigate,
                      style: TextButton.styleFrom(backgroundColor: Colors.blue),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'Create Account',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
