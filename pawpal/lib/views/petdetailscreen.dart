import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/loginscreen.dart';
import 'package:pawpal/views/donationscreen.dart';

class PetDetailScreen extends StatefulWidget {
  final MyPet pet;
  final User? user;

  const PetDetailScreen({super.key, required this.pet, this.user});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> submitAdoptionRequest() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a message!")));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse("${MyConfig.baseUrl}/pawpal/api/submit_adoption.php"),
        body: {
          "petid": widget.pet.petId.toString(),
          "userid": widget.user!.userId.toString(),
          "motivation": _messageController.text.trim(),
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Adoption request sent successfully!")),
        );
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit request")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error, please try again")),
      );
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Details"),
        backgroundColor: const Color.fromARGB(255, 213, 185, 84),
        actions: [
          if (widget.user?.userId == widget.pet.userId.toString())
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () => _deletePetDialog(context),
            ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PET IMAGE
            if (pet.imagePaths != null && pet.imagePaths!.isNotEmpty)
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      '${MyConfig.baseUrl}/pawpal/uploads/pets/${pet.petImage}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // PET NAME
            Text(
              pet.petName ?? "Unnamed Pet",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _detailChip("Type: ${pet.petType}"),
                _detailChip("Category: ${pet.category}"),
                _detailChip("Age: ${pet.age ?? 'Unknown'}"),
                _detailChip("Gender: ${pet.gender ?? 'Unknown'}"),
                _detailChip("Health: ${pet.health ?? 'Healthy'}"),
              ],
            ),
            const SizedBox(height: 20),

            // DESCRIPTION
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              pet.description ?? "No description available",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            const Divider(),
            const SizedBox(height: 10),

            // TASK 3: Navigation to Donation
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 195, 175, 252),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.volunteer_activism, color: Colors.black),
              label: const Text(
                "HELP THIS PET",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DonationScreen(pet: widget.pet, user: widget.user!),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // ADOPTION FORM
            if (widget.user != null) ...[
              const Text(
                "Adoption Request",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Why do you want to adopt this pet?",
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 213, 185, 84),
                  ),
                  onPressed: _isSubmitting ? null : submitAdoptionRequest,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit Adoption Request",
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ),
            ] else ...[
              _loginPrompt(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
      ),
    );
  }

  Widget _loginPrompt() {
    return Center(
      child: Column(
        children: [
          const Text("You must be logged in to adopt this pet."),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text("Login Now"),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _deletePetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Pet?"),
          content: const Text(
            "Are you sure you want to delete this pet record? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                _deletePet();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePet() async {
    try {
      final response = await http.post(
        Uri.parse("${MyConfig.baseUrl}/pawpal/api/delete_pet.php"),
        body: {"petid": widget.pet.petId.toString()},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pet deleted successfully")),
          );
          Navigator.pop(
            context,
            "refresh",
          ); // Return to MainScreen and trigger reload
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
