import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/views/petdetailscreen.dart';

class AllPetScreen extends StatefulWidget {
  final User? user;
  const AllPetScreen({super.key, this.user});

  @override
  State<AllPetScreen> createState() => _AllPetScreenState();
}

class _AllPetScreenState extends State<AllPetScreen> {
  // Variables kept exactly as requested
  TextEditingController searchController = TextEditingController();
  String selectedType = "All";
  List<MyPet> myPets = [];
  late double screenWidth, screenHeight;
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog();
      },
      child: Scaffold(
        appBar: buildModernAppBar(),
        drawer: MyDrawer(user: widget.user),
        body: Column(
          children: [
            searchAndFilterBar(),
            Expanded(
              child: myPets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.find_in_page_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(status, style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: myPets.length,
                      itemBuilder: (context, index) {
                        final pet = myPets[index];
                        return petCard(pet);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // TASK 1: Display pet cards (image + name + type + age)
  Widget petCard(MyPet pet) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // TASK 1: Clicking a pet opens the Pet Details screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PetDetailScreen(pet: pet, user: widget.user),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  // Updated dynamic image path logic
                  '${MyConfig.baseUrl}/pawpal/php/${pet.imagePaths![0]}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.pets, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.petName ?? "Unnamed",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Type: ${pet.petType}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      "Age: ${pet.age} years",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // TASK 1: Search bar (name) and Filter (dropdown)
  Widget searchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by pet name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) => loadPets(),
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: selectedType,
            items: ["All", "Cat", "Dog", "Other"].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (value) {
              setState(() => selectedType = value!);
              loadPets();
            },
          ),
        ],
      ),
    );
  }

  // TASK 1: Fetch via PHP API (GET)
  Future<void> loadPets() async {
    setState(() {
      myPets.clear();
      status = "Loading...";
    });

    try {
      // We safely handle null user by using ?. and the ?? operator
      String userIdParam = widget.user?.userId?.toString() ?? "guest";

      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/get_all_pets.php'
          '?userid=$userIdParam'
          '&search=${searchController.text}'
          '&type=$selectedType',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          setState(() {
            myPets = jsonResponse['data']
                .map<MyPet>((item) => MyPet.fromJson(item))
                .toList();
          });
        } else {
          setState(() => status = "No pets found");
        }
      } else {
        setState(() => status = "Server error");
      }
    } catch (e) {
      log("Error: $e");
      setState(() => status = "Network error");
    }
  }

  AppBar buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 253, 240, 157),
      foregroundColor: Colors.white,
      title: const Text("Pawpal Adoption"),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => loadPets(),
        ),
      ],
    );
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
