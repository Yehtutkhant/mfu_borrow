import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mfuborrow/utils/constants.dart';
import 'package:mfuborrow/utils/get_token.dart';

class EditProfileScreen extends StatefulWidget {
  final String? image;
  final String username;
  final String email;
  final String studentId;
  const EditProfileScreen({
    super.key,
    this.image,
    required this.username,
    required this.email,
    required this.studentId,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  String? _existingImage;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _existingImage = widget.image;
    _nameController.text = widget.username;
    _emailController.text = widget.email;
    _studentIdController.text = widget.studentId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> _handleEdit() async {
    setState(() {
      isLoading = true;
    });
    try {
      Uri uri = Uri.parse('$url/api/profile');
      String token = await getToken(context);
      final request = http.MultipartRequest('PUT', uri)
        ..headers['authorization'] = 'Bearer $token'
        ..fields['username'] = _nameController.text
        ..fields['email'] = _emailController.text
        ..fields['student_id'] = _studentIdController.text;

      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profile_image', _image!.path),
        );
      }
      final streamed =
          await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode == 201) {
        if (!mounted) return;
        Map? message = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${message?['message'] ?? "Unvalid inputs"}'),
            backgroundColor: Colors.red, // Custom background
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              top: kToolbarHeight + 16, // Offset below app bar
              left: 16,
              right: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        if (!mounted) return;
        Map? message = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${message?['message'] ?? "Unvalid inputs"}'),
            backgroundColor: Colors.red, // Custom background
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              top: kToolbarHeight + 16, // Offset below app bar
              left: 16,
              right: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on TimeoutException catch (e) {
      debugPrint(e.message);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Connection Time Out"),
          backgroundColor:
              const Color.fromARGB(255, 29, 22, 21), // Custom background
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            top: kToolbarHeight + 16, // Offset below app bar
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Unknow Error"),
          backgroundColor:
              const Color.fromARGB(255, 29, 22, 21), // Custom background
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            top: kToolbarHeight + 16, // Offset below app bar
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Picture with Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : _existingImage != null
                          ? NetworkImage(_existingImage!) as ImageProvider
                          : null,
                  child: (_image == null && _existingImage == null)
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap to change profile picture',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 10),
              buildProfileField(
                icon: Icons.person,
                labelText: 'Name',
                controller: _nameController,
              ),
              buildProfileField(
                icon: Icons.email,
                labelText: 'Email',
                controller: _emailController,
              ),
              buildProfileField(
                icon: Icons.badge,
                labelText: 'Student ID',
                controller: _studentIdController,
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleEdit,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileField({
    required IconData icon,
    required String labelText,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}
