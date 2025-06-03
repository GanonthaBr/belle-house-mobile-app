class PropertyImage {
  final int id;
  final String image;
  final String createdAt;

  const PropertyImage({
    required this.id,
    required this.image,
    required this.createdAt,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'created_at': createdAt};
  }
}

class PropertyCategory {
  final int id;
  final String name;
  final String description;
  final String createdAt;

  const PropertyCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory PropertyCategory.fromJson(Map<String, dynamic> json) {
    return PropertyCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
    };
  }
}

class Property {
  final int id;
  final PropertyCategory category;
  final String name;
  final double price;
  final String description;
  final String typeOfContract;
  final String area;
  final String images;
  final double size;
  final String agentName;
  final int kitchen;
  final int bedrooms;
  final int bathrooms;
  final List<PropertyImage> moreImages;

  const Property({
    required this.category,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.typeOfContract,
    required this.area,
    required this.images,
    required this.size,
    required this.agentName,
    required this.kitchen,
    required this.bedrooms,
    required this.bathrooms,
    this.moreImages = const [],
  });

  // Factory constructor for creating Property from JSON/Map
  factory Property.fromJson(Map<String, dynamic> json) {
    List<PropertyImage> moreImagesList = [];
    if (json['more_images'] != null) {
      moreImagesList =
          (json['more_images'] as List)
              .map((imageJson) => PropertyImage.fromJson(imageJson))
              .toList();
    }

    return Property(
      category: PropertyCategory.fromJson(json['category'] ?? {}),
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description'] ?? '',
      typeOfContract: json['type_of_contract'] ?? '',
      area: json['area'] ?? '',
      images: json['images'] ?? '',
      size: double.tryParse(json['size']?.toString() ?? '0') ?? 0.0,
      agentName: json['agent_name'] ?? '',
      kitchen:
          int.tryParse(json['kichen']?.toString() ?? '0') ??
          0, // Note the typo in API
      bedrooms: int.tryParse(json['bedrooms']?.toString() ?? '0') ?? 0,
      bathrooms: int.tryParse(json['bathrooms']?.toString() ?? '0') ?? 0,
      moreImages: moreImagesList,
    );
  }

  // Convert Property to JSON/Map
  Map<String, dynamic> toJson() {
    return {
      'category': category.toJson(),
      'name': name,
      'id': id,
      'price': price,
      'description': description,
      'type_of_contract': typeOfContract,
      'area': area,
      'images': images,
      'size': size,
      'agent_name': agentName,
      'kichen': kitchen, // Keep the API typo for consistency
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
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

  // Convenience getters for backward compatibility with your existing UI
  String get imagePath => images;
  String get contractType => typeOfContract;
  String get location => area;
  int get kitchens => kitchen;

  // Optional: Copy method for creating modified copies
  Property copyWith({
    PropertyCategory? category,
    String? name,
    double? price,
    String? description,
    String? typeOfContract,
    String? area,
    String? images,
    double? size,
    String? agentName,
    int? kitchen,
    int? bedrooms,
    int? bathrooms,
    List<PropertyImage>? moreImages,
  }) {
    return Property(
      id: id,
      category: category ?? this.category,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      typeOfContract: typeOfContract ?? this.typeOfContract,
      area: area ?? this.area,
      images: images ?? this.images,
      size: size ?? this.size,
      agentName: agentName ?? this.agentName,
      kitchen: kitchen ?? this.kitchen,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      moreImages: moreImages ?? this.moreImages,
    );
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'Property(name: $name, price: $price, area: $area, typeOfContract: $typeOfContract, size: $size, agentName: $agentName, bedrooms: $bedrooms, bathrooms: $bathrooms, kitchen: $kitchen, moreImages: ${moreImages.length})';
  }

  // Optional: Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Property &&
        other.category == category &&
        other.name == name &&
        other.price == price &&
        other.description == description &&
        other.typeOfContract == typeOfContract &&
        other.area == area &&
        other.images == images &&
        other.size == size &&
        other.agentName == agentName &&
        other.kitchen == kitchen &&
        other.bedrooms == bedrooms &&
        other.bathrooms == bathrooms;
  }

  @override
  int get hashCode {
    return Object.hash(
      category,
      name,
      price,
      description,
      typeOfContract,
      area,
      images,
      size,
      agentName,
      kitchen,
      bedrooms,
      bathrooms,
    );
  }
}

class Category {
  final int id;
  final String name;
  final String description;
  final String createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
    };
  }
}
