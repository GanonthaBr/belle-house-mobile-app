import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    // Extract additional product details that might not be shown in the grid
    final Map<String, dynamic> additionalDetails =
        widget.product['additionalDetails'] ?? {};
    final List<String> availableOptions = widget.product['options'] ?? [];
    final List<Map<String, dynamic>> similarProducts =
        widget.product['similarProducts'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
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
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product-${widget.product['name']}',
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(widget.product['image'], fit: BoxFit.cover),
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
                                widget.product['inStock']
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.product['inStock']
                                ? 'In Stock'
                                : 'Out of Stock',
                            style: TextStyle(
                              color:
                                  widget.product['inStock']
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          widget.product['category'] ??
                              'Construction Materials',
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
                      widget.product['name'],
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
                          '\$${widget.product['price'].toStringAsFixed(2)}/${widget.product['unit']}',
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
                            widget.product['brand'] ?? 'Premium Brand',
                            true,
                          ),
                          if (widget.product.containsKey('weight'))
                            _buildSpecificationRow(
                              'Weight',
                              widget.product['weight'],
                              false,
                            ),
                          if (widget.product.containsKey('size'))
                            _buildSpecificationRow(
                              'Size',
                              widget.product['size'],
                              true,
                            ),
                          if (widget.product.containsKey('volume'))
                            _buildSpecificationRow(
                              'Volume',
                              widget.product['volume'],
                              false,
                            ),
                          if (widget.product.containsKey('length'))
                            _buildSpecificationRow(
                              'Length',
                              widget.product['length'],
                              true,
                            ),
                          if (widget.product.containsKey('coverage'))
                            _buildSpecificationRow(
                              'Coverage',
                              widget.product['coverage'],
                              false,
                            ),
                          _buildSpecificationRow(
                            'Material',
                            widget.product['material'] ?? 'Various',
                            true,
                          ),
                          _buildSpecificationRow(
                            'Origin',
                            widget.product['origin'] ?? 'Local',
                            false,
                          ),
                          _buildSpecificationRow(
                            'SKU',
                            widget.product['sku'] ??
                                'CM-${widget.product['name'].hashCode}',
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
                      widget.product['description'] ??
                          'This premium ${widget.product['name']} is perfect for construction and decoration projects. Made with high-quality materials to ensure durability and excellent performance. Suitable for both professional contractors and DIY enthusiasts.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),

                    // If available options exist
                    if (availableOptions.isNotEmpty) ...[
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
                            availableOptions.map((option) {
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
                        if (widget.product['category'] == 'Cement' ||
                            widget.product['name'].contains('Cement'))
                          _buildTipItem(
                            'Mix with clean water at the recommended ratio.',
                          ),
                        if (widget.product['category'] == 'Paint' ||
                            widget.product['name'].contains('Paint'))
                          _buildTipItem(
                            'Apply in thin, even coats and allow proper drying time between applications.',
                          ),
                      ],
                    ),

                    // Similar products section
                    if (similarProducts.isNotEmpty) ...[
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
                          itemCount: similarProducts.length,
                          itemBuilder: (context, index) {
                            final similarProduct = similarProducts[index];
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
                                      image: DecorationImage(
                                        image: AssetImage(
                                          similarProduct['image'],
                                        ),
                                        fit: BoxFit.cover,
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
                                          similarProduct['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '\$${similarProduct['price'].toStringAsFixed(2)}',
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
                      '\$${(widget.product['price'] * quantity).toStringAsFixed(2)}',
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
                      widget.product['inStock']
                          ? () {
                            // Implement add to cart functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added ${quantity} ${widget.product['name']} to cart',
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
                    widget.product['inStock'] ? 'Add to Cart' : 'Out of Stock',
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
