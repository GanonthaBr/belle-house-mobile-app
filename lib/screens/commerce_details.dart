import 'package:flutter/material.dart';
import 'package:mobile_app/models/product_model.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/widgets/image_gallery.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product; // Use Product object instead of Map

  const ProductDetailScreen({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;
  List<String> selectedOptions = [];
  PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    // Get all images from the product
    final List<String> allImages = widget.product.allImages;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Image Gallery
            SliverAppBar(
              expandedHeight: screenHeight * 0.35,
              pinned: true,
              backgroundColor: AppColors.primaryColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // Implement share functionality
                  },
                ),
                // Gallery button (if more than one image)
                if (allImages.length > 1)
                  IconButton(
                    icon: Icon(Icons.photo_library, color: Colors.white),
                    onPressed: () => _showImageGallery(context, allImages),
                  ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product-${widget.product.name}',
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image Gallery
                      allImages.isNotEmpty
                          ? Stack(
                            children: [
                              // Image PageView
                              PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                itemCount: allImages.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    allImages[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Icon(
                                            Icons.shopping_bag,
                                            size: 64,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      );
                                    },
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              // Image indicators (if more than one image)
                              if (allImages.length > 1)
                                Positioned(
                                  bottom: 90,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      allImages.length,
                                      (index) => Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              _currentImageIndex == index
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(
                                                    0.5,
                                                  ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // Image counter (if more than one image)
                              if (allImages.length > 1)
                                Positioned(
                                  bottom: 115,
                                  right: 20,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      '${_currentImageIndex + 1}/${allImages.length}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                          : Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.shopping_bag,
                                size: 64,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),

                      // Gradient overlay for better text visibility
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Product Details
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status and category
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                widget.product.inStock
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.product.inStock
                                ? 'In Stock'
                                : 'Out of Stock',
                            style: TextStyle(
                              color:
                                  widget.product.inStock
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          widget.product.categoryName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Product name
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Price and quantity selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.product.price.toString()} FCFA',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, size: 18),
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                },
                              ),
                              Text(
                                '$quantity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, size: 18),
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Image gallery section (if more images exist)
                    if (widget.product.moreImages.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gallery',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed:
                                () => _showImageGallery(context, allImages),
                            child: Text('View All (${allImages.length})'),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              allImages.length > 4 ? 4 : allImages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap:
                                  () => _showImageGallery(
                                    context,
                                    allImages,
                                    initialIndex: index,
                                  ),
                              child: Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(allImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child:
                                    index == 3 && allImages.length > 4
                                        ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+${allImages.length - 3}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                        : null,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24),
                    ],

                    // Specifications
                    Text(
                      'Specifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Product specifications table
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildSpecificationRow(
                            'Brand',
                            widget.product.brand ?? 'Premium Brand',
                            true,
                          ),
                          if (widget.product.weight != null)
                            _buildSpecificationRow(
                              'Weight',
                              widget.product.weight!,
                              false,
                            ),
                          if (widget.product.size != null)
                            _buildSpecificationRow(
                              'Size',
                              widget.product.size!,
                              true,
                            ),
                          if (widget.product.volume != null)
                            _buildSpecificationRow(
                              'Volume',
                              widget.product.volume!,
                              false,
                            ),
                          if (widget.product.length != null)
                            _buildSpecificationRow(
                              'Length',
                              widget.product.length!,
                              true,
                            ),
                          if (widget.product.coverage != null)
                            _buildSpecificationRow(
                              'Coverage',
                              widget.product.coverage!,
                              false,
                            ),
                          _buildSpecificationRow(
                            'Material',
                            widget.product.material ?? 'Various',
                            true,
                          ),
                          _buildSpecificationRow(
                            'Origin',
                            widget.product.origin ?? 'Local',
                            false,
                          ),
                          _buildSpecificationRow(
                            'SKU',
                            widget.product.sku ?? 'PRD-${widget.product.id}',
                            true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Description
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      widget.product.description.isNotEmpty
                          ? widget.product.description
                          : 'This premium ${widget.product.name} is perfect for your needs. Made with high-quality materials to ensure durability and excellent performance.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),

                    // If available options exist
                    if (widget.product.options.isNotEmpty) ...[
                      SizedBox(height: 24),

                      Text(
                        'Available Options',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 12),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            widget.product.options.map((option) {
                              final bool isSelected = selectedOptions.contains(
                                option,
                              );
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedOptions.remove(option);
                                    } else {
                                      selectedOptions.add(option);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? AppColors.primaryColor
                                              : Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],

                    SizedBox(height: 24),

                    // Usage tips
                    Text(
                      'Usage Tips',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Tips list
                    Column(
                      children: [
                        _buildTipItem(
                          'Store in a dry place away from direct sunlight.',
                        ),
                        _buildTipItem(
                          'Follow manufacturer instructions for best results.',
                        ),
                        _buildTipItem(
                          'Use appropriate protective equipment when handling.',
                        ),
                        if (widget.product.categoryName.contains(
                              'Construction',
                            ) ||
                            widget.product.name.toLowerCase().contains(
                              'cement',
                            ))
                          _buildTipItem(
                            'Mix with clean water at the recommended ratio.',
                          ),
                        if (widget.product.categoryName.contains('Paint') ||
                            widget.product.name.toLowerCase().contains('paint'))
                          _buildTipItem(
                            'Apply in thin, even coats and allow proper drying time between applications.',
                          ),
                      ],
                    ),

                    // Similar products section
                    if (widget.product.similarProducts.isNotEmpty) ...[
                      SizedBox(height: 32),

                      Text(
                        'Similar Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 16),

                      Container(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.product.similarProducts.length,
                          itemBuilder: (context, index) {
                            final similarProduct =
                                widget.product.similarProducts[index];
                            final String similarImageUrl =
                                similarProduct['image'] ?? '';
                            final bool hasSimilarImage =
                                similarImageUrl.isNotEmpty;

                            return Container(
                              width: 160,
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product image
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                      color: Colors.grey[200],
                                    ),
                                    child:
                                        hasSimilarImage
                                            ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(8),
                                                  ),
                                              child: Image.network(
                                                similarImageUrl,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Center(
                                                    child: Icon(
                                                      Icons.shopping_bag,
                                                      color: Colors.grey[400],
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                            : Center(
                                              child: Icon(
                                                Icons.shopping_bag,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          similarProduct['name'] ?? 'Product',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${(similarProduct['price'] ?? 0.0).toString()} FCFA',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom bar with Add to Cart button
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Total price calculation
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '${(widget.product.price * quantity).toString()} FCFA',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Add to cart button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed:
                      widget.product.inStock
                          ? () {
                            // Implement add to cart functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added $quantity ${widget.product.name} to cart',
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                backgroundColor: AppColors.primaryColor,
                              ),
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.product.inStock ? 'Add to Cart' : 'Out of Stock',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show full screen image gallery
  void _showImageGallery(
    BuildContext context,
    List<String> images, {
    int initialIndex = 0,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                ImageGalleryScreen(images: images, initialIndex: initialIndex),
      ),
    );
  }

  // Helper method for specification rows
  Widget _buildSpecificationRow(String label, String value, bool isEven) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isEven ? Colors.grey[100] : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Helper method for tip items
  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: AppColors.primaryColor, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
