import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mfuborrow/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mfuborrow/utils/get_token.dart';

// Widget for the Create Asset screen
class CreateAsset extends StatefulWidget {
  const CreateAsset({super.key});

  @override
  State<CreateAsset> createState() => _CreateAssetState();
}

class _CreateAssetState extends State<CreateAsset> {
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String selectedCategory = "Select category"; // Default category
  String selectedStatus = 'Available'; // Default status
  File? _image; // Stores image file selected from device

  // Function to return color based on status
  Color _getAssetStatusColor(context, status) {
    if (status == "Available") {
      return Theme.of(context).colorScheme.onSecondary;
    } else if (status == "Disabled") {
      return Theme.of(context).colorScheme.error;
    } else if (status == "Borrowed") {
      return Theme.of(context).colorScheme.primary;
    } else if (status == "Onholded") {
      return const Color.fromARGB(227, 247, 227, 47);
    }
    return Colors.black;
  }

  // Function to show options for image selection
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('From Gallery'),
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _image = File(pickedFile.path);
                  Navigator.of(context).pop();
                });
              }
            },
          ),
        );
      },
    );
  }

  // Function to create Asset and display a SnackBar

  void _createAsset() async {
    String token = await getToken(context);
    setState(() {
      isLoading = true;
    });

    try {
      Uri uri = Uri.parse('$url/api/asset');
      final request = http.MultipartRequest('POST', uri)
        ..headers['authorization'] = 'Bearer $token'
        ..fields['asset_name'] = _nameController.text
        ..fields['description'] = _descriptionController.text
        ..fields['category'] = selectedCategory
        ..fields['location'] = _locationController.text
        ..fields['status'] = selectedStatus;

      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('asset_image', _image!.path),
        );
      }
      final streamed = await request.send().timeout(const Duration(seconds: 5));
      final response = await http.Response.fromStream(streamed);
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Asset Created Successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top +
                  kToolbarHeight +
                  8, // Offset below app bar
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
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top +
                  kToolbarHeight +
                  8, // Offset below app bar
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
          content: const Text("Connection Time out"),
          backgroundColor:
              const Color.fromARGB(255, 29, 22, 21), // Custom background
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +
                kToolbarHeight +
                8, // Offset below app bar
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
          content: const Text("Unknown Error"),
          backgroundColor:
              const Color.fromARGB(255, 29, 22, 21), // Custom background
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +
                kToolbarHeight +
                8, // Offset below app bar
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          'Create',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Image selection section
                InkWell(
                  onTap: _pickImage,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.add, size: 40),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Asset Name input field
                Text(
                  "Asset Name",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    hintText: 'MacBook Pro...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Dropdown for selecting category
                Text(
                  "Category",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: [
                    'Select category',
                    'Book',
                    'Laptop',
                    'Lab Tool',
                    'Projector',
                    'Audio-Visual',
                    'Entertainment',
                  ]
                      .map((String category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Description input field
                Text(
                  "Description",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    hintText: 'Describe asset....',
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                    border: const OutlineInputBorder(),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),

                // Location input field
                Text(
                  "Location",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    hintText: "MFU Library...",
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                    border: const OutlineInputBorder(),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),

                // Dropdown for selecting status with color based on status
                Text(
                  "Status",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: ['Available', 'Onholded', 'Borrowed', 'Disabled']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        _getAssetStatusColor(context, status),
                                  ),
                            ),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Create Asset button
                Center(
                  child: FilledButton(
                    onPressed: _createAsset,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
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
                        : Text(
                            "Create",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
