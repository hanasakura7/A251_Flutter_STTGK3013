import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/myconfig.dart';

class EditPetScreen extends StatefulWidget {
  final MyPet myPets;

  const EditPetScreen({super.key, required this.myPets});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
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

  late double width, height;

  @override
  void initState() {
    super.initState();

    // Initialize controllers and dropdowns with existing pet data
    petNameController.text = widget.myPets.petName ?? '';
    petDescController.text = widget.myPets.description ?? '';
    selectedPetType = widget.myPets.petType ?? 'Cat';
    selectedSubmissionCategory = widget.myPets.category ?? 'Adoption';
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    width = width > 400 ? 400 : width;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pet 🐾')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Image picker & display
                  GestureDetector(
                    onTap: () =>
                        kIsWeb ? pickWebImage() : pickMobileImageDialog(),
                    child: Container(
                      width: width,
                      height: height / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade400),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: buildImageDisplay(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Pet name
                  TextField(
                    controller: petNameController,
                    decoration: const InputDecoration(
                      labelText: "Pet Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Pet type dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Pet Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: petTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    initialValue: selectedPetType,
                    onChanged: (val) => setState(() => selectedPetType = val!),
                  ),
                  const SizedBox(height: 10),

                  // Category dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: submissionCategory
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    initialValue: selectedSubmissionCategory,
                    onChanged: (val) =>
                        setState(() => selectedSubmissionCategory = val!),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  TextField(
                    controller: petDescController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),

                  // Submit button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      minimumSize: Size(width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: submitPetDialog,
                    child: const Text(
                      'Submit',
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

  // Builds image display or placeholder
  Widget buildImageDisplay() {
    if (images.isEmpty && webImages.isEmpty) {
      if (widget.myPets.petId != null) {
        return Image.network(
          '${MyConfig.baseUrl}/pawpal/assets/petImages/pet_${widget.myPets.petId}.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 60, color: Colors.grey),
        );
      } else {
        return const Center(
          child: Icon(Icons.camera_alt, size: 60, color: Colors.grey),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (!kIsWeb)
            for (var img in images)
              Padding(
                padding: const EdgeInsets.all(4),
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
                padding: const EdgeInsets.all(4),
                child: Image.memory(
                  img,
                  width: 120,
                  height: height / 3,
                  fit: BoxFit.cover,
                ),
              ),
        ],
      ),
    );
  }

  // Mobile image picker dialog
  void pickMobileImageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick Image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                pickMobileImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickMobileImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Pick a single mobile image
  Future<void> pickMobileImage(ImageSource source) async {
    if (images.length >= maxImages) return;

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File? cropped = await cropImage(File(pickedFile.path));
      if (cropped != null) setState(() => images.add(cropped));
    }
  }

  // Pick web image
  Future<void> pickWebImage() async {
    if (webImages.length >= maxImages) return;

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => webImages.add(bytes));
    }
  }

  // Crop image (mobile only)
  Future<File?> cropImage(File imageFile) async {
    if (kIsWeb) return imageFile;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  // Validation & submit confirmation dialog
  void submitPetDialog() {
    if (petNameController.text.trim().isEmpty ||
        petDescController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields!")),
      );
      return;
    }

    if (petDescController.text.trim().length < 10) {
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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Submit Pet"),
        content: const Text("Do you want to submit this pet?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              submitPet();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  // Submit pet to server
  void submitPet() async {
    String base64Images = '';
    if (kIsWeb) {
      base64Images = webImages.map((e) => base64Encode(e)).join(',');
    } else {
      base64Images = images
          .map((e) => base64Encode(e.readAsBytesSync()))
          .join(',');
    }

    var response = await http.post(
      Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_pets.php'),
      body: {
        'petid': widget.myPets.petId.toString(),
        'userid': widget.myPets.userId,
        'pet_name': petNameController.text.trim(),
        'pet_type': selectedPetType,
        'category': selectedSubmissionCategory,
        'description': petDescController.text.trim(),
        'images': base64Images,
      },
    );

    var res = jsonDecode(response.body);
    if (res['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message']), backgroundColor: Colors.red),
      );
    }
  }
}
