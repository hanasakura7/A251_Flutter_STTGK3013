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
  String? age;
  String? gender;
  String? health;

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
    this.lng,
    this.age,
    this.gender,
    this.health,
  });

  MyPet.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id']?.toString();
    userId = json['user_id']?.toString();
    petName = json['pet_name']?.toString() ?? "Unknown Pet";
    petType = json['pet_type']?.toString();
    category = json['category']?.toString();
    description = json['description']?.toString();
    imagePaths = json['image_paths']?.toString();
    petImage = json['pet_image']?.toString(); 
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
    age = json['age']?.toString(); 
    gender = json['gender']?.toString(); 
    health = json['health']?.toString(); 
  }
}