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
  });

  // Factory constructor for creating Land from JSON/Map
  factory Land.fromJson(Map<String, dynamic> json) {
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
    };
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
    );
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'Land(id: $id, name: $name, price: $price, area: $area, landType: $landType, size: $size)';
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
