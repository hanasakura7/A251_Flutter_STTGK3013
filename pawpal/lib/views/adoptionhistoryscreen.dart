import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class AdoptionHistoryScreen extends StatefulWidget {
  final User user;
  const AdoptionHistoryScreen({super.key, required this.user});

  @override
  State<AdoptionHistoryScreen> createState() => _AdoptionHistoryScreenState();
}

class _AdoptionHistoryScreenState extends State<AdoptionHistoryScreen> {
  List _historyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      var url = Uri.parse("${MyConfig.baseUrl}/pawpal/api/get_adoption_history.php?user_id=${widget.user.userId}");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          setState(() => _historyList = data['data']);
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Adoption Requests"),
        backgroundColor: const Color.fromARGB(255, 213, 185, 84),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _historyList.isEmpty 
          ? const Center(child: Text("No adoption requests found."))
          : ListView.builder(
              itemCount: _historyList.length,
              itemBuilder: (context, index) {
                var item = _historyList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "${MyConfig.baseUrl}/pawpal/${item['image_paths'][0]}"
                      ),
                    ),
                    title: Text("Pet: ${item['pet_name']}"),
                    subtitle: Text("Applied on: ${item['created_at']}"),
                    trailing: _buildStatusBadge(item['adoption_status']),
                  ),
                );
              },
            ),
    );
  }

  // Helper to show different colors for different statuses
  Widget _buildStatusBadge(String status) {
    Color badgeColor = Colors.orange; // Pending
    if (status == 'Approved') badgeColor = Colors.green;
    if (status == 'Rejected') badgeColor = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}