import 'package:flutter/material.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/providers/house_provider.dart';
import 'package:mobile_app/screens/commerce_details.dart';
import 'package:mobile_app/screens/lands.dart';
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

      // Load location data
      await authProvider.getCountryAndCity();

      // Load houses data
      await houseProvider.getHouseList();

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
        print('There you go: $housesList');
        return SliverList(
          delegate: SliverChildListDelegate([
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
                        child: Text(
                          'Voir tout',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Check if houses data is loading or empty
                  if (houseProvider.isLoading)
                    Container(
                      height: height * 0.28,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  else if (housesList == null || housesList.isEmpty)
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
                            SizedBox(height: 10),
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
                    )
                  else
                    // Horizontal scrolling properties with real data
                    Container(
                      height: height * 0.35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            housesList.length > 10
                                ? 10
                                : housesList
                                    .length, // Limit to 10 items for performance
                        itemBuilder: (context, index) {
                          final house = housesList[index];

                          // Add type checking to ensure house is a Map
                          if (house is! Map<String, dynamic>) {
                            print('Invalid house data at index $index: $house');
                            return SizedBox.shrink(); // Return empty widget for invalid data
                          }

                          return GestureDetector(
                            onTap: () {
                              // Pass the house data to details screen
                              Navigator.pushNamed(
                                context,
                                '/house_details',
                                arguments: house, // Pass the house object
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              house['images']?.toString() ??
                                                  'https://images.unsplash.com/photo-1613490493576-7fde63acd811',
                                            ),
                                            fit: BoxFit.cover,
                                            onError: (exception, stackTrace) {
                                              // Handle image loading error
                                              print(
                                                'Error loading image: $exception',
                                              );
                                            },
                                          ),
                                        ),
                                        // Fallback for when image fails to load
                                        child:
                                            (house['images'] == null ||
                                                    house['images']
                                                        .toString()
                                                        .isEmpty)
                                                ? Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                16,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                16,
                                                              ),
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.home,
                                                      size: 40,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                )
                                                : null,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                (house['type_of_contract']
                                                                ?.toString() ??
                                                            '') ==
                                                        'sale'
                                                    ? 'Vente'
                                                    : 'Location',
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${_formatPrice(house['price'])} FCFA',
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        // House name
                                        Text(
                                          house['name']?.toString() ?? 'Maison',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.grey[500],
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              house['area']?.toString() ??
                                                  'N/A',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                    ),
                ],
              ),
            ),

            // Rest of your existing content (Sponsored banners section, etc.)
            // ... (keep the existing _showAnnonceDetails and other sections as they are)

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
  // Home content (original content)
  // Widget _buildHomeContent(double width, double height) {
  //   return SliverList(
  //     delegate: SliverChildListDelegate([
  //       // Most popular section
  //       Container(
  //         padding: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   'PLUS POPULAIRES',
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.grey[600],
  //                     letterSpacing: 0.5,
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(right: width * 0.05),
  //                   child: Text(
  //                     'Voir tout',
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w500,
  //                       color: AppColors.primaryColor,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 15),
  //             // Horizontal scrolling properties
  //             Container(
  //               height: height * 0.28,
  //               child: ListView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 itemCount: 5,
  //                 itemBuilder: (context, index) {
  //                   return GestureDetector(
  //                     onTap: () {
  //                       Navigator.pushNamed(context, '/house_details');
  //                       // print('Clicked');
  //                     },
  //                     child: Container(
  //                       width: width * 0.65,
  //                       margin: EdgeInsets.only(right: 15),
  //                       decoration: BoxDecoration(
  //                         color: AppColors.secondaryColor,
  //                         borderRadius: BorderRadius.circular(16),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.grey.withOpacity(0.1),
  //                             spreadRadius: 0,
  //                             blurRadius: 10,
  //                             offset: Offset(0, 3),
  //                           ),
  //                         ],
  //                       ),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           // Property image with like button
  //                           Stack(
  //                             children: [
  //                               Container(
  //                                 height: height * 0.18,
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.only(
  //                                     topLeft: Radius.circular(16),
  //                                     topRight: Radius.circular(16),
  //                                   ),
  //                                   image: DecorationImage(
  //                                     image: NetworkImage(
  //                                       index == 0
  //                                           ? 'https://images.unsplash.com/photo-1613490493576-7fde63acd811'
  //                                           : 'https://images.unsplash.com/photo-1531971589569-0d9370cbe1e5',
  //                                     ),
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                                 ),
  //                               ),
  //                               Positioned(
  //                                 top: 10,
  //                                 right: 10,
  //                                 child: Container(
  //                                   padding: EdgeInsets.all(8),
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.white.withOpacity(0.9),
  //                                     shape: BoxShape.circle,
  //                                   ),
  //                                   child: Icon(
  //                                     Icons.favorite_border,
  //                                     color: Colors.grey[600],
  //                                     size: 20,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           // Property details
  //                           Padding(
  //                             padding: EdgeInsets.all(12),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Container(
  //                                       padding: EdgeInsets.symmetric(
  //                                         horizontal: 10,
  //                                         vertical: 6,
  //                                       ),
  //                                       decoration: BoxDecoration(
  //                                         color: AppColors.primaryColor
  //                                             .withOpacity(0.1),
  //                                         borderRadius: BorderRadius.circular(
  //                                           20,
  //                                         ),
  //                                       ),
  //                                       child: Text(
  //                                         'Vente',
  //                                         style: TextStyle(
  //                                           color: AppColors.primaryColor,
  //                                           fontWeight: FontWeight.w600,
  //                                           fontSize: 12,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       '2000.0 FCFA',
  //                                       style: TextStyle(
  //                                         color: AppColors.primaryColor,
  //                                         fontWeight: FontWeight.bold,
  //                                         fontSize: 14,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 SizedBox(height: 2),
  //                                 Row(
  //                                   children: [
  //                                     Icon(
  //                                       Icons.location_on,
  //                                       color: Colors.grey[500],
  //                                       size: 16,
  //                                     ),
  //                                     SizedBox(width: 4),
  //                                     Text(
  //                                       'Pala-Francophonie',
  //                                       style: TextStyle(
  //                                         color: Colors.grey[700],
  //                                         fontSize: 13,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),

  //       // Sponsored banners section (Les Annonces)
  //       Container(
  //         padding: EdgeInsets.symmetric(
  //           horizontal: width * 0.05,
  //           vertical: height * 0.02,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'LES ANNONCES',
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.grey[600],
  //                 letterSpacing: 0.5,
  //               ),
  //             ),
  //             SizedBox(height: 15),
  //             GestureDetector(
  //               onTap: () => _showAnnonceDetails(context),
  //               child: Container(
  //                 height: height * 0.12,
  //                 decoration: BoxDecoration(
  //                   color: Colors.orange[50],
  //                   borderRadius: BorderRadius.circular(15),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.grey.withOpacity(0.1),
  //                       spreadRadius: 0,
  //                       blurRadius: 5,
  //                       offset: Offset(0, 2),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       width: width * 0.2,
  //                       decoration: BoxDecoration(
  //                         color: Colors.orange,
  //                         borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(15),
  //                           bottomLeft: Radius.circular(15),
  //                         ),
  //                       ),
  //                       child: Center(
  //                         child: Icon(
  //                           Icons.campaign,
  //                           color: Colors.white,
  //                           size: 30,
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Padding(
  //                         padding: EdgeInsets.all(10),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               'Offres spéciales',
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 15,
  //                               ),
  //                             ),
  //                             SizedBox(height: 4),
  //                             Text(
  //                               'Découvrez nos nouvelles propriétés à prix réduits',
  //                               style: TextStyle(
  //                                 color: Colors.grey[600],
  //                                 fontSize: 12,
  //                               ),
  //                               maxLines: 2,
  //                               overflow: TextOverflow.ellipsis,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.only(right: 10),
  //                       padding: EdgeInsets.symmetric(
  //                         horizontal: 12,
  //                         vertical: 6,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: AppColors.primaryColor,
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: Text(
  //                         'Voir',
  //                         style: TextStyle(
  //                           color: AppColors.secondaryColor,
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             // Add more annonces here if needed
  //             SizedBox(height: height * 0.03),
  //           ],
  //         ),
  //       ),

  //       // Add some bottom padding
  //       SizedBox(height: 20),
  //     ]),
  //   );
  // }

  // Maisons placeholder content
  Widget _buildMaisonsContent(double width, double height) {
    // Sample property data (you would normally fetch this from your backend)
    final List<Map<String, dynamic>> properties = [
      {
        'name': 'Villa Moderne',
        'price': 450000.00,
        'size': 240.50,
        'description':
            'Magnifique villa contemporaine avec jardin spacieux et piscine. Quartier calme et sécurisé.',
        'area': 'Plateau',
        'type_of_contract': 'sale',
        'image': 'assets/images/house1.jpg',
      },
      {
        'name': 'Appartement de Luxe',
        'price': 180000.00,
        'size': 120.75,
        'description':
            'Appartement haut de gamme avec vue imprenable, finitions de qualité, cuisine équipée.',
        'area': 'Cocody',
        'type_of_contract': 'sale',
        'image': 'assets/images/house2.jpg',
      },
      {
        'name': 'Maison Familiale',
        'price': 2500.00,
        'size': 180.30,
        'description':
            'Grande maison familiale avec 4 chambres, jardin, cuisine spacieuse et garage pour 2 voitures.',
        'area': 'Treichville',
        'type_of_contract': 'rent',
        'image': 'assets/images/house3.jpg',
      },
      {
        'name': 'Studio Moderne',
        'price': 850.00,
        'size': 45.00,
        'description':
            'Studio meublé et rénové, idéal pour étudiant ou jeune professionnel. Proche des transports.',
        'area': 'Marcory',
        'type_of_contract': 'rent',
        'image': 'assets/images/house4.jpg',
      },
      {
        'name': 'Résidence Les Palmiers',
        'price': 350000.00,
        'size': 195.80,
        'description':
            'Résidence sécurisée avec 3 chambres, terrasse, piscine commune et espace vert partagé.',
        'area': 'Riviera',
        'type_of_contract': 'sale',
        'image': 'assets/images/house5.jpg',
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ...properties.map(
              (property) => _buildPropertyCard(property, width),
            ),
            SizedBox(height: 50), // Additional space at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property, double width) {
    final isRent = property['type_of_contract'] == 'rent';
    final formattedPrice = NumberFormat.currency(
      symbol: isRent ? 'FCFA ' : 'FCFA ',
      decimalDigits: 0,
    ).format(property['price']);

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
                Image.asset(
                  property['image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.home,
                          size: 60,
                          color: Colors.grey[500],
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
                  children: [
                    Expanded(
                      child: Text(
                        property['name'],
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
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: Colors.grey[600],
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
                    Text(
                      property['area'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  property['description'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Navigator.pushNamed(context, '/house_details');
                    // print('Clicked');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  child: Text(
                    'Voir détails',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
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
  Widget _buildParcellesContent(double width, double height) {
    // Example data - replace with your actual data source
    final List<Map<String, dynamic>> parcelles = [
      {
        'id': 1,
        'name': 'Parcelle A',
        'location': 'Niamey Nord',
        'size': '500 m²',
        'price': 250000,
        'image': 'assets/images/land1.jpg',
      },
      {
        'id': 2,
        'name': 'Parcelle B',
        'location': 'Zone Résidentielle',
        'size': '800 m²',
        'price': 450000,
        'image': 'assets/images/land2.jpg',
      },
      {
        'id': 3,
        'name': 'Parcelle C',
        'location': 'Quartier Plateau',
        'size': '600 m²',
        'price': 320000,
        'image': 'assets/images/land3.jpg',
      },
      {
        'id': 4,
        'name': 'Parcelle D',
        'location': 'Yantala',
        'size': '450 m²',
        'price': 190000,
        'image': 'assets/images/land4.jpg',
      },
      {
        'id': 5,
        'name': 'Parcelle E',
        'location': 'Boukoki',
        'size': '750 m²',
        'price': 380000,
        'image': 'assets/images/land5.jpg',
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              ],
            ),
            SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > 700 ? 3 : 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: parcelles.length,
              itemBuilder: (context, index) {
                final parcelle = parcelles[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ParcelleDetailScreen(parcelle: parcelle),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Land image
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              image: DecorationImage(
                                image: AssetImage(parcelle['image']),
                                fit: BoxFit.cover,
                              ),
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
                                    Text(
                                      parcelle['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            parcelle['location'],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${parcelle['size']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${parcelle['price']} FCFA',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                        fontSize: 14,
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
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Shopping placeholder content
  Widget _buildShoppingContent(double width, double height) {
    // Sample construction materials and decoration/finishing items
    final List<Map<String, dynamic>> products = [
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

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SHOPPING',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 15),
            // Display grid of products
            GridView.builder(
              physics:
                  NeverScrollableScrollPhysics(), // Disable scroll within grid
              shrinkWrap: true, // Important to work inside CustomScrollView
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return InkWell(
                  onTap: () {
                    // Navigate to product detail screen when a product is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProductDetailScreen(product: product),
                      ),
                    );
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
                            image: DecorationImage(
                              image: AssetImage(product['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  product['inStock']
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product['inStock'] ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Product details
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              // Display product specifications
                              if (product.containsKey('weight'))
                                _buildSpecText('Weight: ${product['weight']}'),
                              if (product.containsKey('size'))
                                _buildSpecText('Size: ${product['size']}'),
                              if (product.containsKey('volume'))
                                _buildSpecText('Volume: ${product['volume']}'),
                              if (product.containsKey('length'))
                                _buildSpecText('Length: ${product['length']}'),
                              if (product.containsKey('coverage'))
                                _buildSpecText(
                                  'Coverage: ${product['coverage']}',
                                ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${product['price'].toStringAsFixed(2)}/${product['unit']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.primaryColor,
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
                                        Icons.add_shopping_cart,
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
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Filter or category buttons
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
  }

  // Helper method for building specification text
  Widget _buildSpecText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Helper method for building category filter buttons
  Widget _buildCategoryButton(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {
          // Filter products based on category
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? AppColors.primaryColor : Colors.white,
          backgroundColor: isSelected ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.primaryColor),
          ),
          elevation: isSelected ? 2 : 0,
        ),
        child: Text(label),
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
