import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/submitpetscreen.dart';
import 'package:pawpal/views/petdetailscreen.dart';
import 'package:pawpal/shared/mydrawer.dart';

class MainScreen extends StatefulWidget {
  final User? user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<MyPet> myPets = [];
  List<MyPet> filteredPets = [];
  String selectedType = "All";
  List<String> petTypes = ["All", "Cat", "Dog", "Other"];
  String status = "Loading...";
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  bool showWelcome = true;
  late double width, height;

  // Controller for the search bar
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        showWelcome = false;
      });
      loadMyPets();
    });
  }

  // Suggestion: Filter logic based on Pet Type
  void filterPets(String query) {
    setState(() {
      filteredPets = myPets.where((pet) {
        // 1. Check if name contains search text
        bool matchesName = pet.petName.toString().toLowerCase().contains(
          query.toLowerCase(),
        );

        // 2. Check if type matches dropdown selection
        bool matchesType =
            (selectedType == "All") || (pet.petType.toString() == selectedType);

        return matchesName && matchesType;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width > 400) {
      width = 400;
    } else {
      width = width;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(" PawPal 🐾"),
        // Task 1: Search bar + Dropdown in PreferredSize
        bottom: showWelcome
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(
                  120,
                ), // Height for two rows
                child: Column(
                  children: [
                    // Row 1: Search by Name
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: filterPets,
                        decoration: InputDecoration(
                          hintText: "Search by Pet Name...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    // Row 2: Filter by Type Dropdown (Requirement 3.2)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedType,
                            isExpanded: true,
                            items: petTypes.map((String type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue!;
                              });
                              filterPets(
                                searchController.text,
                              ); // Apply filter immediately
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
      ),
      drawer: MyDrawer(user: widget.user),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetScreen(user: widget.user!),
            ),
          );
          loadMyPets();
        },
      ),

      body: Stack(
        children: [
          Center(child: showWelcome ? Container() : buildMainContent()),
          if (showWelcome)
            Container(
              color: Colors.white,
              child: Center(
                child: AnimatedOpacity(
                  opacity: showWelcome ? 1.0 : 0.0,
                  duration: const Duration(seconds: 3),
                  child: Text(
                    'Welcome, ${widget.user?.userName ?? "User"}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  //build main content
  Widget buildMainContent() {
    if (status == "Loading...") {
      return const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 232, 217, 164),
        ),
      );
    }

    // Suggestion: Wrapped with RefreshIndicator to allow pull-to-refresh
    return RefreshIndicator(
      onRefresh: () async => loadMyPets(),
      child: filteredPets.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      status == "" ? "No pets found" : status,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SubmitPetScreen(user: widget.user!),
                          ),
                        ).then((_) => loadMyPets());
                      },
                      child: const Text("Add Pet"),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: filteredPets.length, // Uses filtered list
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailScreen(
                          pet: filteredPets[index],
                          user: widget.user!,
                        ),
                      ),
                    ).then((value) => loadMyPets());
                  },
                  child: buildPetCard(filteredPets[index], index),
                );
              },
            ),
    );
  }

  //load dari database
  void loadMyPets() async {
    if (!mounted) return;

    setState(() {
      status = "Loading...";
      myPets.clear();
      filteredPets.clear();
    });

    try {
      final response = await http.get(
        Uri.parse(
          "${MyConfig.baseUrl}/pawpal/api/get_my_pets.php?user_id=${widget.user!.userId}",
        ),
      );

      if (response.statusCode == 200) {
        final resarray = jsonDecode(response.body);

        if (resarray['status'] == 'success') {
          List petsData = resarray['data'] ?? [];

          myPets = petsData.map<MyPet>((item) {
            List<dynamic> images = item['image_paths'] ?? [];

            if (item['image_paths'] != null &&
                item['image_paths'].toString().isNotEmpty) {
              try {
                if (item['image_paths'] is String) {
                  images = jsonDecode(item['image_paths']);
                } else if (item['image_paths'] is List) {
                  images = item['image_paths'];
                }
              } catch (e) {
                images = [];
              }
            }

            String? thumbnail = images.isNotEmpty ? images[0] : null;
            return MyPet.fromJson({...item, 'pet_image': thumbnail});
          }).toList();

          setState(() {
            filteredPets = myPets; // Update filtered list with full data
            status = myPets.isEmpty ? "No pets yet" : "";
          });
        } else {
          setState(() {
            status = "No pets found";
          });
        }
      } else {
        setState(() {
          status = "Server error (${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        status = "Error loading pets: $e";
      });
    }
  }

  Widget buildPetCard(MyPet pet, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: width * 0.28,
                height: width * 0.22,
                color: const Color.fromARGB(255, 99, 79, 4),
                child: Image.network(
                  // Removed hardcoded .PNG to allow database-defined extension
                  "${MyConfig.baseUrl}/pawpal/${pet.petImage}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.petName.toString(),
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Type: ${pet.petType.toString()}",
                    style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 224, 80, 80)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Category: ${pet.category.toString()}",
                    style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 95, 78, 209)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Description: ${pet.description.toString()}",
                    style: const TextStyle(fontSize: 14, color: Color.fromARGB(221, 216, 0, 249)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
