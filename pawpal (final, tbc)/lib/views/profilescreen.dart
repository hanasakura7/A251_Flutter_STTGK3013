import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  User user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  File? _imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    nameController.text = widget.user.userName ?? '';
    phoneController.text = widget.user.userPhone ?? '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => isLoading = true);

    String? base64Image;
    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    try {
      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_profile.php'),
        body: {
          'user_id': widget.user.userId!,
          'user_name': nameController.text,
          'user_phone': phoneController.text,
          if (base64Image != null) 'profile_image': base64Image,
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        widget.user.userName = nameController.text;
        widget.user.userPhone = phoneController.text;
        if (data['profile_image'] != null) {
          widget.user.userprofileImage = data['profile_image'];
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', jsonEncode(widget.user.toJson()));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );

        setState(() => _imageFile = null);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Update failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildAvatar() {
    // 1. If the user just picked a NEW image locally
    if (_imageFile != null) {
      return CircleAvatar(radius: 50, backgroundImage: FileImage(_imageFile!));
    }

    // 2. If there is an existing profile image on the server
    // Check both userprofileImage and profileImage based on your model's naming
    String? imagePath =
        widget.user.userprofileImage ?? widget.user.userprofileImage;

    if (imagePath != null && imagePath.isNotEmpty && imagePath != "null") {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(
          '${MyConfig.baseUrl}/pawpal/uploads/profile/$imagePath',
        ),
        // Error listener to catch 404s gracefully
        onBackgroundImageError: (exception, stackTrace) {
          debugPrint("Image load failed: $exception");
        },
      );
    }

    // 3. Fallback: Show Initials if no image exists
    return CircleAvatar(
      radius: 50,
      backgroundColor: const Color.fromARGB(
        255,
        213,
        185,
        84,
      ), // Match your theme color
      child: Text(
        (widget.user.userName != null && widget.user.userName!.isNotEmpty)
            ? widget.user.userName![0].toUpperCase()
            : '?',
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      drawer: MyDrawer(user: widget.user),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAvatar(),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Change Photo"),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text("Save Changes"),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
