import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/submitpetscreen.dart';

class MainScreen extends StatefulWidget {
  final User? user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<MyPet> myPets = [];
  String status = "Loading...";
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  bool showWelcome = true;
  late double width, height;

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
      appBar: AppBar(title: Text(" PawPal 🐾")),
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
                    'Welcome, ${widget.user!.userName}!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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

    if (myPets.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(status, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubmitPetScreen(user: widget.user!),
                ),
              ).then((_) => loadMyPets());
            },
            child: Text("Add Pet"),
          ),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: myPets.length,
        itemBuilder: (context, index) {
          return buildPetCard(myPets[index], index);
        },
      );
    }
  }

  //load dari database
  void loadMyPets() async {
    if (!mounted) return;

    setState(() {
      status = "Loading...";
      myPets.clear(); // Clear previous pets to avoid duplicates
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

          // Map API data to MyPet objects
          myPets = petsData.map<MyPet>((item) {
            List<dynamic> images = item['image_paths'] ?? [];

            // Handle empty or malformed image_paths
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
                width: width * 0.28, // more responsive
                height: width * 0.22,
                color: Color.fromARGB(255, 99, 79, 4),
                child: Image.network(
                  "${MyConfig.baseUrl}/pawpal/uploads/${pet.petImage}.PNG",
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
                    style: const TextStyle(fontSize: 17, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Type: ${pet.petType.toString()}",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Category: ${pet.category.toString()}",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Description: ${pet.description.toString()}",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} //enddddddddddddddd
