//tengok balik

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/views/mainscreen.dart';

class SubmitPetScreen extends StatefulWidget {
  final User? user;
  const SubmitPetScreen({super.key, required this.user});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  List<String> petTypes = ['Cat', 'Dog', 'Rabbit', 'Other'];
  List<String> submissionCategory = [
    'Adoption',
    'Donation Request',
    'Help/Rescue',
  ];

  TextEditingController petNameController = TextEditingController();
  TextEditingController petDescController = TextEditingController();

  String selectedPetType = 'Cat';
  String selectedSubmissionCategory = 'Adoption';

  List<File> images = [];
  List<Uint8List> webImages = [];
  final int maxImages = 3;

  double? latitude;
  double? longitude;

  bool isLoading = false;

  late double width, height;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width > 400) width = 400;

    return Scaffold(
      appBar: AppBar(title: const Text("Submit Pet 🐾")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (kIsWeb) {
                        pickWebImage();
                      } else {
                        pickMobileImage();
                      }
                    },
                    child: images.isEmpty && webImages.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_alt,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Tap to add image",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (!kIsWeb)
                                  for (var img in images)
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.file(
                                        img,
                                        width: 120,
                                        height: height / 3,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                if (kIsWeb)
                                  for (var img in webImages)
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.memory(
                                        img,
                                        width: 120,
                                        height: height / 3,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: petNameController,
                    decoration: const InputDecoration(
                      labelText: "Pet Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Pet Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: petTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    value: selectedPetType, // your selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPetType = newValue!;
                        print(selectedPetType);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: submissionCategory.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    value: selectedSubmissionCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSubmissionCategory = newValue!;
                        print(selectedSubmissionCategory);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: petDescController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: "$latitude"),
                    decoration: InputDecoration(labelText: "Latitude"),
                    readOnly: true,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: "$longitude"),
                    decoration: InputDecoration(labelText: "Longitude"),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 99, 79, 4),
                      minimumSize: Size(width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    onPressed: submitPetDialog,
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission denied forever.');
    }

    Position pos = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
    });
  }

  // Mobile image picker
  Future<void> pickMobileImage() async {
    if (images.length >= maxImages) return;
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) setState(() => images.add(File(pickedFile.path)));
  }

  // Web image picker
  Future<void> pickWebImage() async {
    if (webImages.length >= maxImages) return;
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => webImages.add(bytes));
    }
  }

  void submitPetDialog() {
    String name = petNameController.text.trim();
    String desc = petDescController.text.trim();

    if (name.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields!")),
      );
      return;
    }

    if (desc.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Description must be at least 10 characters!"),
        ),
      );
      return;
    }

    if (images.isEmpty && webImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least 1 image!")),
      );
      return;
    }

    if ((images.length + webImages.length) > maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maximum 3 images allowed!")),
      );
      return;
    }

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Location not available")));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Submit Pet"),
        content: const Text("Do you want to submit this pet?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              submitPet();
            },
            child: const Text("Submit"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void submitPet() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Submitting..."),
            ],
          ),
        ),
      );

      var uri = Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_pet.php');
      var request = http.MultipartRequest('POST', uri);

      request.fields['user_id'] = widget.user!.userId.toString();
      request.fields['pet_name'] = petNameController.text.trim();
      request.fields['pet_type'] = selectedPetType;
      request.fields['category'] = selectedSubmissionCategory;
      request.fields['description'] = petDescController.text.trim();
      request.fields['lat'] = latitude.toString();
      request.fields['lng'] = longitude.toString();

      // Add images
      if (!kIsWeb) {
        for (int i = 0; i < images.length; i++) {
          var imgFile = await http.MultipartFile.fromPath(
            'images[]',
            images[i].path,
          );
          request.files.add(imgFile);
        }
      } else {
        for (int i = 0; i < webImages.length; i++) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'images[]',
              webImages[i],
              filename: 'pet_${DateTime.now().millisecondsSinceEpoch}_$i.png',
            ),
          );
        }
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (mounted) Navigator.pop(context); // close loading dialog safely

      var res = jsonDecode(responseBody.body);

      if (res['status'] == 'success') {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Pet Submitted"),
            content: const Text("Your pet has been successfully submitted."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainScreen(user: widget.user!),
                    ),
                  );

                  // STOP the function immediately
                  return;
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res['message'])));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
}
