class LandImage {
  final int id;
  final String image;
  final String createdAt;

  const LandImage({
    required this.id,
    required this.image,
    required this.createdAt,
  });

  factory LandImage.fromJson(Map<String, dynamic> json) {
    return LandImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'created_at': createdAt};
  }
}

class Land {
  final int id;
  final double price;
  final String description;
  final String name;
  final String area;
  final String landType;
  final double size;
  final String images;
  final int category;
  final List<LandImage> moreImages;

  const Land({
    required this.id,
    required this.price,
    required this.description,
    required this.name,
    required this.area,
    required this.landType,
    required this.size,
    required this.images,
    required this.category,
    this.moreImages = const [],
  });

  // Factory constructor for creating Land from JSON/Map
  factory Land.fromJson(Map<String, dynamic> json) {
    List<LandImage> moreImagesList = [];
    if (json['more_images'] != null) {
      moreImagesList =
          (json['more_images'] as List)
              .map((imageJson) => LandImage.fromJson(imageJson))
              .toList();
    }

    return Land(
      id: json['id'] ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description'] ?? '',
      name: json['name'] ?? '',
      area: json['area'] ?? '',
      landType: json['land_type'] ?? '',
      size: double.tryParse(json['size']?.toString() ?? '0') ?? 0.0,
      images: json['images'] ?? '',
      category: json['category'] ?? 0,
      moreImages: moreImagesList,
    );
  }

  // Convert Land to JSON/Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'description': description,
      'name': name,
      'area': area,
      'land_type': landType,
      'size': size,
      'images': images,
      'category': category,
      'more_images': moreImages.map((img) => img.toJson()).toList(),
    };
  }

  // Get all images (main + more images)
  List<String> get allImages {
    List<String> allImagesList = [];
    if (images.isNotEmpty) {
      allImagesList.add(images);
    }
    allImagesList.addAll(moreImages.map((img) => img.image));
    return allImagesList;
  }

  // Convenience getters for UI compatibility
  String get imagePath => images;
  String get location => area;
  String get ownerName => name;

  // Optional: Copy method for creating modified copies
  Land copyWith({
    int? id,
    double? price,
    String? description,
    String? name,
    String? area,
    String? landType,
    double? size,
    String? images,
    int? category,
    List<LandImage>? moreImages,
  }) {
    return Land(
      id: id ?? this.id,
      price: price ?? this.price,
      description: description ?? this.description,
      name: name ?? this.name,
      area: area ?? this.area,
      landType: landType ?? this.landType,
      size: size ?? this.size,
      images: images ?? this.images,
      category: category ?? this.category,
      moreImages: moreImages ?? this.moreImages,
    );
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'Land(id: $id, name: $name, price: $price, area: $area, landType: $landType, size: $size, moreImages: ${moreImages.length})';
  }

  // Optional: Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Land &&
        other.id == id &&
        other.price == price &&
        other.description == description &&
        other.name == name &&
        other.area == area &&
        other.landType == landType &&
        other.size == size &&
        other.images == images &&
        other.category == category;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      price,
      description,
      name,
      area,
      landType,
      size,
      images,
      category,
    );
  }
}
