class ProductImage {
  final int id;
  final String image;
  final String createdAt;

  const ProductImage({
    required this.id,
    required this.image,
    required this.createdAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'created_at': createdAt};
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String images;
  final int category;
  final List<ProductImage> moreImages;

  // Additional properties that your UI expects (with defaults)
  final String? brand;
  final String? material;
  final String? origin;
  final String? size;
  final String? weight;
  final String? volume;
  final String? length;
  final String? coverage;
  final String unit;
  final bool inStock;
  final String categoryName;
  final String? sku;
  final List<String> options;
  final List<Map<String, dynamic>> similarProducts;
  final Map<String, dynamic> additionalDetails;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
    this.moreImages = const [],
    this.brand,
    this.material,
    this.origin,
    this.size,
    this.weight,
    this.volume,
    this.length,
    this.coverage,
    this.unit = 'piece',
    this.inStock = true,
    this.categoryName = 'Furniture',
    this.sku,
    this.options = const [],
    this.similarProducts = const [],
    this.additionalDetails = const {},
  });

  // Factory constructor for creating Product from JSON/Map
  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductImage> moreImagesList = [];
    if (json['more_images'] != null) {
      moreImagesList =
          (json['more_images'] as List)
              .map((imageJson) => ProductImage.fromJson(imageJson))
              .toList();
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description'] ?? '',
      images: json['images'] ?? '',
      category: json['category'] ?? 0,
      moreImages: moreImagesList,
      brand: json['brand'],
      material: json['material'],
      origin: json['origin'],
      size: json['size'],
      weight: json['weight'],
      volume: json['volume'],
      length: json['length'],
      coverage: json['coverage'],
      unit: json['unit'] ?? 'piece',
      inStock: json['inStock'] ?? json['in_stock'] ?? true,
      categoryName:
          json['categoryName'] ??
          json['category_name'] ??
          _getCategoryName(json['category']),
      sku: json['sku'],
      options: List<String>.from(json['options'] ?? []),
      similarProducts: List<Map<String, dynamic>>.from(
        json['similarProducts'] ?? json['similar_products'] ?? [],
      ),
      additionalDetails: Map<String, dynamic>.from(
        json['additionalDetails'] ?? json['additional_details'] ?? {},
      ),
    );
  }

  // Helper method to determine category name based on category ID
  static String _getCategoryName(int? categoryId) {
    switch (categoryId) {
      case 1:
        return 'Construction Materials';
      case 2:
        return 'Tools';
      case 3:
        return 'Paint & Coatings';
      case 4:
        return 'Electrical';
      case 5:
        return 'Plumbing';
      case 6:
        return 'Furniture';
      case 7:
        return 'Decoration';
      default:
        return 'General';
    }
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

  // Convert Product to JSON/Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'images': images,
      'category': category,
      'more_images': moreImages.map((img) => img.toJson()).toList(),
      'brand': brand,
      'material': material,
      'origin': origin,
      'size': size,
      'weight': weight,
      'volume': volume,
      'length': length,
      'coverage': coverage,
      'unit': unit,
      'inStock': inStock,
      'categoryName': categoryName,
      'sku': sku,
      'options': options,
      'similarProducts': similarProducts,
      'additionalDetails': additionalDetails,
    };
  }

  // Convert to format expected by ProductDetailScreen
  Map<String, dynamic> toProductDetailFormat() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description':
          description.isNotEmpty ? description : 'No description available',
      'image': images, // Note: UI expects 'image' not 'images'
      'category': categoryName,
      'brand': brand ?? 'Premium Brand',
      'material': material ?? 'Various',
      'origin': origin ?? 'Local',
      'size': size,
      'weight': weight,
      'volume': volume,
      'length': length,
      'coverage': coverage,
      'unit': unit,
      'inStock': inStock,
      'sku': sku ?? 'PRD-$id',
      'options': options,
      'similarProducts': similarProducts,
      'additionalDetails': additionalDetails,
      'allImages': allImages, // Include all images for gallery
      'moreImages': moreImages.map((img) => img.toJson()).toList(),
    };
  }

  // Convenience getters for UI compatibility
  String get imagePath => images;
  String get productName => name;

  // Optional: Copy method for creating modified copies
  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? images,
    int? category,
    List<ProductImage>? moreImages,
    String? brand,
    String? material,
    String? origin,
    String? size,
    String? weight,
    String? volume,
    String? length,
    String? coverage,
    String? unit,
    bool? inStock,
    String? categoryName,
    String? sku,
    List<String>? options,
    List<Map<String, dynamic>>? similarProducts,
    Map<String, dynamic>? additionalDetails,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      category: category ?? this.category,
      moreImages: moreImages ?? this.moreImages,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      origin: origin ?? this.origin,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      volume: volume ?? this.volume,
      length: length ?? this.length,
      coverage: coverage ?? this.coverage,
      unit: unit ?? this.unit,
      inStock: inStock ?? this.inStock,
      categoryName: categoryName ?? this.categoryName,
      sku: sku ?? this.sku,
      options: options ?? this.options,
      similarProducts: similarProducts ?? this.similarProducts,
      additionalDetails: additionalDetails ?? this.additionalDetails,
    );
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $categoryName, inStock: $inStock, moreImages: ${moreImages.length})';
  }

  // Optional: Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.description == description &&
        other.images == images &&
        other.category == category;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, price, description, images, category);
  }
}
