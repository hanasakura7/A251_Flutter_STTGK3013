import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/petdetailscreen.dart';

class MyPetsScreen extends StatefulWidget {
  final User user;
  const MyPetsScreen({super.key, required this.user});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  List<MyPet> myPetList = [];

  @override
  void initState() {
    super.initState();
    _loadMyPets();
  }

  Future<void> _loadMyPets() async {
    // SYNC: Notice the key 'user_id' matches your PHP script
    var url = Uri.parse("${MyConfig.baseUrl}/pawpal/api/get_my_pets.php?user_id=${widget.user.userId}");
    
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var list = data['data'] as List;
          setState(() {
            myPetList = list.map((json) => MyPet.fromJson(json)).toList();
          });
        }
      }
    } catch (e) {
      print("Error loading pets: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Uploaded Pets")),
      body: myPetList.isEmpty
          ? const Center(child: Text("You haven't posted any pets yet."))
          : ListView.builder(
              itemCount: myPetList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      "${MyConfig.baseUrl}/pawpal/${myPetList[index].imagePaths![0]}",
                      width: 50, height: 50, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets),
                    ),
                    title: Text(myPetList[index].petName ?? ""),
                    subtitle: Text(myPetList[index].petType ?? ""),
                    onTap: () async {
                      // Navigate to details and wait for potential refresh (if deleted)
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) => PetDetailScreen(pet: myPetList[index], user: widget.user))
                      );
                      if (result == "refresh") _loadMyPets();
                    },
                  ),
                );
              },
            ),
    );
  }
}