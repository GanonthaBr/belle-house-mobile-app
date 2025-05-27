// models/house.dart
class House {
  final int id;
  final Category category;
  final String name;
  final double price;
  final String description;
  final String typeOfContract;
  final String area;
  final String? images;

  House({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.description,
    required this.typeOfContract,
    required this.area,
    this.images,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'] ?? 0,
      category: Category.fromJson(json['category'] ?? {}),
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      typeOfContract: json['type_of_contract'] ?? '',
      area: json['area'] ?? '',
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.toJson(),
      'name': name,
      'price': price,
      'description': description,
      'type_of_contract': typeOfContract,
      'area': area,
      'images': images,
    };
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
