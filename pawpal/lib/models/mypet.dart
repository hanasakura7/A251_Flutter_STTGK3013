class MyPet {
  String? petId;
  String? userId;
  String? petName;
  String? petType;
  String? category;
  String? description;
  String? imagePaths; 
  String? petImage;
  String? lat;
  String? lng;

  MyPet({
    this.petId,
    this.userId,
    this.petName,
    this.petType,
    this.category,
    this.description,
    this.imagePaths,
    this.petImage,
    this.lat,
    this.lng
  });

  MyPet.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id'];
    userId = json['user_id'];
    petName = json['pet_name'];
    petType = json['pet_type'];
    category = json['category'];
    description = json['description'];
    imagePaths = json['image_paths'];
    petImage = json['pet_image'];
    lat = json['lat'];
    lng = json['lng'];
  }
}
