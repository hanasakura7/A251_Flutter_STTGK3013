import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class MyDonationsScreen extends StatefulWidget {
  final User user;
  const MyDonationsScreen({super.key, required this.user});

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  List donationList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyDonations();
  }

  Future<void> _loadMyDonations() async {
    try {
      final response = await http.get(
        Uri.parse("${MyConfig.baseUrl}/pawpal/php/get_user_donations.php?userid=${widget.user.userId}"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            donationList = data['data'];
          });
        }
      }
    } catch (e) {
      print("Error loading donations: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Donation History"),
        backgroundColor: const Color.fromARGB(255, 213, 185, 84),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : donationList.isEmpty
              ? const Center(child: Text("You haven't made any donations yet."))
              : ListView.builder(
                  itemCount: donationList.length,
                  itemBuilder: (context, index) {
                    var donation = donationList[index];
                    bool isMoney = donation['donation_type'] == "Money";

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          isMoney ? Icons.monetization_on : Icons.inventory_2,
                          color: isMoney ? Colors.green : Colors.orange,
                        ),
                        title: Text("To: ${donation['pet_name']}"),
                        subtitle: Text(isMoney 
                            ? "Amount: RM ${donation['amount']}" 
                            : "Item: ${donation['description']}"),
                        trailing: Text(
                          donation['donated_at'].toString().substring(0, 10),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}