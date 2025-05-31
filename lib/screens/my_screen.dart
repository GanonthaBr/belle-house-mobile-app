import 'package:flutter/material.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/providers/house_provider.dart';
import 'package:mobile_app/providers/lands_provider.dart';
import 'package:mobile_app/providers/products_provider.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final houseProvider = Provider.of<HouseProvider>(context, listen: false);
      final landProvider = Provider.of<LandsProvider>(context, listen: false);
      Provider.of<LandsProvider>(context, listen: false).startAutoRefresh();
      Provider.of<HouseProvider>(context, listen: false).startAutoRefresh();
      final productsProvider = Provider.of<ProductsProvider>(
        context,
        listen: false,
      );
      Provider.of<ProductsProvider>(context, listen: false).startAutoRefresh();

      // Load location data
      await authProvider.getCountryAndCity();

      // Load houses data
      await houseProvider.getHouseList();
      //Load lands
      await landProvider.getLandsList();

      //load products
      await productsProvider.getProductsList();

      // Handle any loading errors
      if (houseProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de chargement: ${houseProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'Accueil',
    'Maisons',
    'Parcelles',
    'Shopping',
  ];
  final List<IconData> _categoryIcons = [
    Icons.home_work_outlined,
    Icons.home_outlined,
    Icons.landscape_outlined,
    Icons.shopping_bag_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }
          final locationInfos = authProvider.countryCity;

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // Top Bar with location and notification
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Location with dropdown
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.location_on,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${locationInfos?['city'].substring(0, 12)} ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),

                        // Notification bell in a container
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.lightPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications_none_outlined,
                                size: 24,
                                color: Colors.grey[800],
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 8,
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.01,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[400]),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Tapez pour rechercher',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.tune,
                              color: AppColors.secondaryColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Categories section - Sticky Header
                SliverPersistentHeader(
                  pinned: true, // This makes it sticky
                  delegate: _StickyHeaderDelegate(
                    minHeight: 125, // Minimum height when collapsed
                    maxHeight: 125, // Maximum height when expanded
                    child: _buildCategoriesSection(
                      width,
                      height,
                      AppColors.primaryColor,
                      AppColors.secondaryColor,
                    ),
                  ),
                ),

                // Content based on selected category
                _buildCategoryContent(width, height),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to build the Categories section
  Widget _buildCategoriesSection(
    double width,
    double height,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Container(
      color: Color(0xFFF5F7FA), // Background color
      padding: EdgeInsets.only(left: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CATEGORIES',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    width: width * 0.2,
                    margin: EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          width: 55,
                          decoration: BoxDecoration(
                            color:
                                _selectedCategoryIndex == index
                                    ? primaryColor
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow:
                                _selectedCategoryIndex == index
                                    ? [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ]
                                    : null,
                          ),
                          child: Icon(
                            _categoryIcons[index],
                            color:
                                _selectedCategoryIndex == index
                                    ? secondaryColor
                                    : Colors.grey[600],
                            size: 26,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _categories[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                _selectedCategoryIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                            color:
                                _selectedCategoryIndex == index
                                    ? Colors.black87
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to build category-specific content
  Widget _buildCategoryContent(double width, double height) {
    // Return different content based on selected category
    switch (_selectedCategoryIndex) {
      case 0: // Accueil
        return _buildHomeContent(width, height);
      case 1: // Maisons
        return _buildMaisonsContent(width, height);
      case 2: // Parcelles
        return _buildParcellesContent(width, height);
      case 3: // Shopping
        return _buildShoppingContent(width, height);
      default:
        return _buildHomeContent(width, height);
    }
  }

  // Home content with real API data integration
  Widget _buildHomeContent(double width, double height) {
    return Consumer<HouseProvider>(
      builder: (context, houseProvider, child) {
        final housesList = houseProvider.housesInfos;

        return SliverList(
          delegate: SliverChildListDelegate([
            // Error handling section at the top
            if (houseProvider.error != null)
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: 8,
                ),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            housesList != null && housesList.isNotEmpty
                                ? 'Données non actualisées'
                                : 'Erreur de chargement',
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!houseProvider.isLoading)
                          GestureDetector(
                            onTap: () => houseProvider.retryLastOperation(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Réessayer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (housesList == null || housesList.isEmpty) ...[
                      SizedBox(height: 8),
                      Text(
                        houseProvider.error!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // Most popular section
            Container(
              padding: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PLUS POPULAIRES',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                          letterSpacing: 0.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: width * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to houses list screen
                            Navigator.pushNamed(context, '/houses');
                          },
                          child: Text(
                            'Voir tout',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Loading state for initial load
                  if (houseProvider.isLoading &&
                      (housesList == null || housesList.isEmpty))
                    SizedBox(
                      height: height * 0.28,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Chargement des maisons...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Empty state (no data and no loading)
                  else if ((housesList == null || housesList.isEmpty) &&
                      !houseProvider.isLoading)
                    SizedBox(
                      height: height * 0.28,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 12),
                            Text(
                              houseProvider.error != null
                                  ? 'Impossible de charger les maisons'
                                  : 'Aucune maison disponible',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (houseProvider.error != null) ...[
                              SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed:
                                    () => houseProvider.retryLastOperation(),
                                icon: Icon(Icons.refresh, size: 18),
                                label: Text('Réessayer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  // Houses list with data
                  else
                    SizedBox(
                      height: height * 0.35,
                      child: Stack(
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                housesList!.length > 10
                                    ? 10
                                    : housesList.length,
                            itemBuilder: (context, index) {
                              final house = housesList[index];

                              // Type checking to ensure house is a Map
                              if (house is! Map<String, dynamic>) {
                                return SizedBox.shrink();
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/house_details',
                                    arguments: house,
                                  );
                                },
                                child: Container(
                                  width: width * 0.65,
                                  margin: EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Property image with like button
                                      Stack(
                                        children: [
                                          Container(
                                            height: height * 0.18,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                              child: _buildHouseImage(
                                                house['images'],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.favorite_border,
                                                color: Colors.grey[600],
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Property details
                                      Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    (house['type_of_contract']
                                                                    ?.toString() ??
                                                                '') ==
                                                            'sale'
                                                        ? 'Vente'
                                                        : 'Location',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${_formatPrice(house['price'])} FCFA',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),

                                            // House name
                                            Text(
                                              house['name']?.toString() ??
                                                  'Maison',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),

                                            // Location
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.grey[500],
                                                  size: 16,
                                                ),
                                                SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    house['area']?.toString() ??
                                                        'N/A',
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 13,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Loading overlay for refresh
                          if (houseProvider.isLoading && housesList.isNotEmpty)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Actualisation...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Sponsored banners section (Les Annonces)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LES ANNONCES',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => _showAnnonceDetails(context),
                    child: Container(
                      height: height * 0.12,
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.campaign,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Offres spéciales',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Découvrez nos nouvelles propriétés à prix réduits',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Voir',
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),

            // Add some bottom padding
            SizedBox(height: 20),
          ]),
        );
      },
    );
  }

  // Helper method to build house image with proper error handling
  Widget _buildHouseImage(dynamic imageUrl) {
    if (imageUrl == null || imageUrl.toString().isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.home, size: 40, color: Colors.grey[500]),
        ),
      );
    }

    return Image.network(
      imageUrl.toString(),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              strokeWidth: 2,
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // print('Error loading house image: $error');
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 32, color: Colors.grey[500]),
                SizedBox(height: 4),
                Text(
                  'Image non disponible',
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to format price with proper number formatting
  String _formatPrice(dynamic price) {
    if (price == null) return '0';

    // Convert to double if it's a string
    double priceValue;
    if (price is String) {
      priceValue = double.tryParse(price) ?? 0.0;
    } else if (price is num) {
      priceValue = price.toDouble();
    } else {
      return '0';
    }

    // Format with thousand separators
    final formatter = NumberFormat('#,###', 'fr_FR');
    return formatter.format(priceValue);
  }

  // Maisons placeholder content
  Widget _buildMaisonsContent(double width, double height) {
    return Consumer<HouseProvider>(
      builder: (context, houseProvider, child) {
        final housesList = houseProvider.housesInfos;
        return SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error handling section at the top
                if (houseProvider.error != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                housesList != null && housesList.isNotEmpty
                                    ? 'Données non actualisées'
                                    : 'Erreur de chargement',
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (!houseProvider.isLoading)
                              GestureDetector(
                                onTap: () => houseProvider.retryLastOperation(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade600,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'Réessayer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (housesList == null || housesList.isEmpty) ...[
                          SizedBox(height: 8),
                          Text(
                            houseProvider.error!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                // Header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MAISONS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all properties page
                      },
                      child: Text(
                        'Voir tout',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Loading state for initial load
                if (houseProvider.isLoading &&
                    (housesList == null || housesList.isEmpty))
                  Container(
                    height: height * 0.28,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Chargement des maisons...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                // Empty state (no data and no loading)
                else if ((housesList == null || housesList.isEmpty) &&
                    !houseProvider.isLoading)
                  Container(
                    height: height * 0.28,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 12),
                          Text(
                            houseProvider.error != null
                                ? 'Impossible de charger les maisons'
                                : 'Aucune maison disponible',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (houseProvider.error != null) ...[
                            SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed:
                                  () => houseProvider.retryLastOperation(),
                              icon: Icon(Icons.refresh, size: 18),
                              label: Text('Réessayer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                // Houses list with data
                else
                  Column(
                    children: [
                      // Show loading overlay if refreshing with existing data
                      if (houseProvider.isLoading &&
                          housesList != null &&
                          housesList.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Actualisation des données...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Houses cards
                      if (housesList != null && housesList.isNotEmpty)
                        ...housesList.map((house) {
                          if (house is! Map<String, dynamic>) {
                            return SizedBox.shrink();
                          }
                          return _buildPropertyCard(house, width);
                        })
                      else
                        SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Aucune maison disponible',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                SizedBox(height: 50), // Bottom spacing
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property, double width) {
    final isRent = property['type_of_contract'] == 'rent';
    final price = double.tryParse(property['price']?.toString() ?? '0') ?? 0.0;
    final formattedPrice = NumberFormat.currency(
      symbol: 'FCFA ',
      decimalDigits: 0,
    ).format(price);

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child:
                      property['images'] != null &&
                              property['images'].toString().isNotEmpty
                          ? Image.network(
                            property['images'].toString(),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.grey[500],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Image non disponible',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          )
                          : Container(
                            color: Colors.grey[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home,
                                  size: 60,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Pas d\'image',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isRent ? Colors.blue : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isRent ? 'À louer' : 'À vendre',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Property details
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property['name']?.toString() ?? 'Maison',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Par: ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            property['agent_name'],
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property['area']?.toString() ?? 'N/A',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  property['description']?.toString() ??
                      'Pas de description disponible',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (property['size'] != null)
                      Row(
                        children: [
                          Icon(
                            Icons.square_foot,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${property['size']} m²',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Superficie: ${property['size'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    Text(
                      formattedPrice + (isRent ? '/mois' : ''),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/house_details',
                      arguments: property,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  child: Text(
                    'Voir détails',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Parcelles placeholder content
  // Corrected _buildParcellesContent method with proper null safety
  Widget _buildParcellesContent(double width, double height) {
    return Consumer<LandsProvider>(
      builder: (context, landProvider, child) {
        final landsList = landProvider.landsInfos; // This can be null
        // print(landsList);
        return SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error handling section at the top
                if (landProvider.error != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                // CORRECTED: Proper null safety check
                                (landsList != null && landsList.isNotEmpty)
                                    ? 'Données non actualisées'
                                    : 'Erreur de chargement',
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (!landProvider.isLoading)
                              GestureDetector(
                                onTap: () => landProvider.retryLastOperation(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade600,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'Réessayer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // CORRECTED: Proper null safety check
                        if (landsList == null || landsList.isEmpty) ...[
                          SizedBox(height: 8),
                          Text(
                            landProvider.error!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                // Header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PARCELLES',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all lands page
                      },
                      child: Text(
                        'Voir tout',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Loading state for initial load
                // CORRECTED: Proper null safety check
                if (landProvider.isLoading &&
                    (landsList == null || landsList.isEmpty))
                  SizedBox(
                    height: height * 0.3,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Chargement des parcelles...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if ((landsList == null || landsList.isEmpty) &&
                    !landProvider.isLoading)
                  Container(
                    height: height * 0.3,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.landscape_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 12),
                          Text(
                            landProvider.error != null
                                ? 'Impossible de charger les parcelles'
                                : 'Aucune parcelle disponible',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (landProvider.error != null) ...[
                            SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed:
                                  () => landProvider.retryLastOperation(),
                              icon: Icon(Icons.refresh, size: 18),
                              label: Text('Réessayer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                // Lands grid with data
                else
                  Column(
                    children: [
                      if (landProvider.isLoading &&
                          landsList != null &&
                          landsList.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Actualisation des parcelles...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (landsList != null && landsList.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: width > 700 ? 3 : 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 7,
                              ),
                          itemCount: landsList.length,
                          itemBuilder: (context, index) {
                            final land = landsList[index];
                            return _buildLandCard(land, context);
                          },
                        )
                      else
                        SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.landscape_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Aucune parcelle disponible',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build land card
  Widget _buildLandCard(dynamic land, BuildContext context) {
    // Handle both Land objects and Map<String, dynamic>
    final Map<String, dynamic> landData;

    if (land is Map<String, dynamic>) {
      landData = land;
    } else {
      // If using Land model class, convert to map
      landData = {
        'id': land.id,
        'name': land.name,
        'area': land.area,
        'size': land.size,
        'price': land.price,
        'images': land.images?.isNotEmpty == true ? land.images!.first : null,
        'type_of_contract': land.typeOfContract,
        'land_type': land.landType,
        'description': land.description,
      };
    }

    final price = double.tryParse(landData['price']?.toString() ?? '0') ?? 0.0;
    final formattedPrice = NumberFormat.currency(
      symbol: 'FCFA ',
      decimalDigits: 0,
    ).format(price);

    final isRent = landData['type_of_contract'] == 'rent';
    final landType = landData['land_type'] ?? 'residential';

    return GestureDetector(
      onTap: () {
        // Navigate to land detail page
        Navigator.pushNamed(context, '/land_details', arguments: landData);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Land image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child:
                            landData['images'] != null &&
                                    landData['images'].toString().isNotEmpty
                                ? Image.network(
                                  landData['images'].toString(),
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        color: Colors.grey[300],
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.broken_image,
                                              size: 30,
                                              color: Colors.grey[500],
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Image non disponible',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                )
                                : Container(
                                  color: Colors.grey[300],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.landscape,
                                        size: 40,
                                        color: Colors.grey[500],
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Pas d\'image',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                      ),
                    ),

                    // Contract type badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isRent ? Colors.blue : AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isRent ? 'Louer' : 'Vente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Land type badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getLandTypeLabel(landType),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Land details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Agent: '),
                            Text(
                              landData['name'].length >= 10
                                  ? landData['name'].substring(0, 15)
                                  : landData['name'] ?? 'Belle House',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                landData['area']?.toString() ?? 'N/A',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${landData['size'] ?? 'N/A'} m²',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              formattedPrice,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        if (isRent)
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '/mois',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get land type label in French
  String _getLandTypeLabel(String landType) {
    switch (landType.toLowerCase()) {
      case 'residential':
        return 'Résidentiel';
      case 'commercial':
        return 'Commercial';
      case 'agricultural':
        return 'Agricole';
      case 'industrial':
        return 'Industriel';
      default:
        return 'Terrain';
    }
  }

  // Shopping placeholder content
  // Shopping content with ProductsProvider consumer
  Widget _buildShoppingContent(double width, double height) {
    return Consumer<ProductsProvider>(
      builder: (context, productsProvider, child) {
        final productsList = productsProvider.productsInfos;
        return SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error handling section at the top
                if (productsProvider.error != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                productsList != null && productsList.isNotEmpty
                                    ? 'Données non actualisées'
                                    : 'Erreur de chargement',
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (!productsProvider.isLoading)
                              GestureDetector(
                                onTap:
                                    () => productsProvider.retryLastOperation(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade600,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'Réessayer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (productsList == null || productsList.isEmpty) ...[
                          SizedBox(height: 8),
                          Text(
                            productsProvider.error!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                // Header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SHOPPING',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all products page
                      },
                      child: Text(
                        'Voir tout',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Loading state for initial load
                if (productsProvider.isLoading &&
                    (productsList == null || productsList.isEmpty))
                  SizedBox(
                    height: height * 0.28,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Chargement des produits...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                // Empty state (no data and no loading)
                else if ((productsList == null || productsList.isEmpty) &&
                    !productsProvider.isLoading)
                  SizedBox(
                    height: height * 0.28,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 12),
                          Text(
                            productsProvider.error != null
                                ? 'Impossible de charger les produits'
                                : 'Aucun produit disponible',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (productsProvider.error != null) ...[
                            SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed:
                                  () => productsProvider.retryLastOperation(),
                              icon: Icon(Icons.refresh, size: 18),
                              label: Text('Réessayer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                // Products grid with data
                else
                  Column(
                    children: [
                      // Show loading overlay if refreshing with existing data
                      if (productsProvider.isLoading &&
                          productsList != null &&
                          productsList.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Actualisation des données...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Products grid - Use provider data if available, otherwise fallback to static data
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 15,
                        ),
                        itemCount:
                            (productsList != null && productsList.isNotEmpty)
                                ? productsList.length
                                : _getStaticProducts().length,
                        itemBuilder: (context, index) {
                          final product = productsList?[index];
                          if (product is! Map<String, dynamic>) {
                            return SizedBox.shrink();
                          }
                          return _buildProductCard(product, context);
                        },
                      ),
                    ],
                  ),

                SizedBox(height: 20),
                // Filter or category buttons (commented out as in original)
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       _buildCategoryButton('All Products', true),
                //       _buildCategoryButton('Construction', false),
                //       _buildCategoryButton('Decoration', false),
                //       _buildCategoryButton('Finishing', false),
                //       _buildCategoryButton('Tools', false),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // Static fallback products (original content)
  List<Map<String, dynamic>> _getStaticProducts() {
    return [
      {
        'name': 'Premium Cement Bags',
        'price': 12.99,
        'unit': 'bag',
        'weight': '50 kg',
        'image': 'images/sofa.png',
        'inStock': true,
      },
      {
        'name': 'Ceramic Floor Tiles',
        'price': 24.50,
        'unit': 'sq.m',
        'size': '60x60 cm',
        'image': 'assets/images/tiles.jpg',
        'inStock': true,
      },
      {
        'name': 'Interior Wall Paint',
        'price': 45.75,
        'unit': 'bucket',
        'volume': '5 L',
        'image': 'assets/images/paint.jpg',
        'inStock': true,
      },
      {
        'name': 'Decorative Molding',
        'price': 8.25,
        'unit': 'piece',
        'length': '2.5 m',
        'image': 'assets/images/molding.jpg',
        'inStock': false,
      },
      {
        'name': 'Steel Rebars',
        'price': 18.99,
        'unit': 'piece',
        'length': '6 m',
        'image': 'assets/images/rebars.jpg',
        'inStock': true,
      },
      {
        'name': 'Laminate Flooring',
        'price': 32.50,
        'unit': 'pack',
        'coverage': '2.5 sq.m',
        'image': 'assets/images/laminate.jpg',
        'inStock': true,
      },
    ];
  }

  Widget _buildProductCard(Map<String, dynamic> product, BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to product detail screen when a product is tapped
        Navigator.pushNamed(context, '/product_details', arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.grey[200],
              ),
              child: Stack(
                children: [
                  // Image container
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child:
                        product['images'] != null
                            ? Image.network(
                              product['images'],
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.broken_image,
                                          size: 30,
                                          color: Colors.grey[500],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Image non disponible',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            )
                            : Container(
                              width: double.infinity,
                              height: 120,
                              color: Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag,
                                    size: 40,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Pas d\'image',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                  // Stock status badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            (product['inStock'] ?? true)
                                ? AppColors.primaryColor
                                : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (product['inStock'] ?? true)
                            ? 'Disponible'
                            : 'Out of Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name']?.toString() ?? 'Product',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    // Display product specifications
                    if (product.containsKey('description'))
                      _buildSpecText(product['description']),
                    if (product.containsKey('size'))
                      _buildSpecText('Size: ${product['size']}'),
                    if (product.containsKey('volume'))
                      _buildSpecText('Volume: ${product['volume']}'),
                    if (product.containsKey('length'))
                      _buildSpecText('Length: ${product['length']}'),
                    if (product.containsKey('coverage'))
                      _buildSpecText('Coverage: ${product['coverage']}'),

                    Spacer(),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${(product['price'] ?? 0.0).toString()} FCFA',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Add to cart functionality
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecText(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[600], fontSize: 11),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Method to show annonce details modal
  void _showAnnonceDetails(BuildContext context) {
    // Get screen dimensions for responsive layout
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;

    // Define color scheme
    const Color primaryColor = Color(0xff61a1d6);
    const Color secondaryColor = Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: height * 0.7,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 5,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Annonce title
                        Text(
                          'Offres spéciales',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Banner image
                        Container(
                          height: height * 0.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1560518883-ce09059eeffa',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Profitez de nos offres spéciales sur les propriétés immobilières à Niamey. Pendant une durée limitée, nous offrons des réductions significatives sur une sélection de maisons et parcelles dans les quartiers les plus prisés de la ville.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Dates
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: primaryColor,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Offre valable du 01/05/2025 au 31/05/2025',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),

                        // Terms
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Conditions de l\'offre:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              _buildTermItem(
                                'Réduction de 10% sur toutes les propriétés sélectionnées',
                              ),
                              _buildTermItem(
                                'Frais de dossier offerts pour tout achat ferme',
                              ),
                              _buildTermItem(
                                'Premier rendez-vous avec un agent immobilier gratuit',
                              ),
                              _buildTermItem(
                                'Service d\'accompagnement juridique à tarif préférentiel',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),

                        // Contact button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Contacter un agent',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Helper method to build term items
  Widget _buildTermItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Color(0xff61a1d6), size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom SliverPersistentHeaderDelegate for the sticky header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
