//user donate to help pet
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class DonationScreen extends StatefulWidget {
  final MyPet pet;
  final User user;

  const DonationScreen({super.key, required this.pet, required this.user});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  String selectedType = "Money";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate to ${widget.pet.petName}"),
        backgroundColor: const Color.fromARGB(255, 213, 185, 84),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How would you like to help?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 1. SELECT DONATION TYPE
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ["Money", "Food", "Medical"].map((String type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // 2. DYNAMIC FIELDS (Money vs Others)
            if (selectedType == "Money") ...[
              const Text("Enter Amount (RM)"),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "0.00",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
            ] else ...[
              Text("Describe the $selectedType item"),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "e.g. 5kg Kibbles, First Aid Kit...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 30),

            // 3. SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 213, 185, 84),
                ),
                onPressed: _isLoading ? null : _submitDonation,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Confirm Donation",
                        style: TextStyle(color: Colors.black),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. SUBMIT TO PHP
  Future<void> _submitDonation() async {
    // Basic Validation
    if (selectedType == "Money" && _amountController.text.isEmpty) return;
    if (selectedType != "Money" && _descController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("${MyConfig.baseUrl}/pawpal/api/submit_donation.php"),
        body: {
          "userid": widget.user.userId.toString(),
          "petid": widget.pet.petId.toString(),
          "type": selectedType,
          "amount": selectedType == "Money" ? _amountController.text : "0",
          "description": selectedType == "Money"
              ? "Cash Donation"
              : _descController.text,
        },
      );

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thank you for your donation!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }

    setState(() => _isLoading = false);
  }
}
