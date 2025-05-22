import 'package:flutter/material.dart';

class Houses extends StatefulWidget {
  const Houses({super.key});

  @override
  State<Houses> createState() => _HousesState();
}

class _HousesState extends State<Houses> {
  // Filter options
  String _selectedFilter = 'Tous';
  final List<String> _filterOptions = ['Tous', 'Location', 'Vente', 'Récent'];

  // Dummy data for houses
  final List<Map<String, dynamic>> _housesList = [
    {
      'image': 'images/BH39.jpg',
      'area': 'Yantala',
      'city': 'Niamey',
      'price': 200000,
      'contractType': 'Location',
      'propertyName': 'BH39',
      'bedrooms': 3,
      'bathrooms': 2,
      'isNew': true,
    },
    {
      'image': 'images/villa_moderne.jpg',
      'area': 'Plateau',
      'city': 'Niamey',
      'price': 350000,
      'contractType': 'Vente',
      'propertyName': 'Villa Moderne',
      'bedrooms': 4,
      'bathrooms': 3,
      'isNew': false,
    },
    {
      'image': 'images/apartment_lux.jpg',
      'area': 'Francophonie',
      'city': 'Niamey',
      'price': 180000,
      'contractType': 'Location',
      'propertyName': 'Apartment Lux',
      'bedrooms': 2,
      'bathrooms': 1,
      'isNew': true,
    },
    {
      'image': 'images/residence_elite.jpg',
      'area': 'Koubia',
      'city': 'Niamey',
      'price': 450000,
      'contractType': 'Vente',
      'propertyName': 'Résidence Elite',
      'bedrooms': 5,
      'bathrooms': 4,
      'isNew': false,
    },
    {
      'image': 'images/maison_jardin.jpg',
      'area': 'Bobiel',
      'city': 'Niamey',
      'price': 280000,
      'contractType': 'Vente',
      'propertyName': 'Maison Jardin',
      'bedrooms': 3,
      'bathrooms': 2,
      'isNew': false,
    },
    {
      'image': 'images/studio_central.jpg',
      'area': 'Centre-ville',
      'city': 'Niamey',
      'price': 120000,
      'contractType': 'Location',
      'propertyName': 'Studio Central',
      'bedrooms': 1,
      'bathrooms': 1,
      'isNew': true,
    },
    {
      'image': 'images/villa_riverside.jpg',
      'area': 'Goudel',
      'city': 'Niamey',
      'price': 390000,
      'contractType': 'Vente',
      'propertyName': 'Villa Riverside',
      'bedrooms': 4,
      'bathrooms': 3,
      'isNew': true,
    },
  ];

  // Filtered houses based on selection
  List<Map<String, dynamic>> get filteredHouses {
    if (_selectedFilter == 'Tous') {
      return _housesList;
    } else if (_selectedFilter == 'Récent') {
      return _housesList.where((house) => house['isNew'] == true).toList();
    } else {
      return _housesList
          .where((house) => house['contractType'] == _selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff61a1d6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maisons Disponibles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                '${filteredHouses.length} propriétés trouvées',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 16),

              // Horizontal filter options
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      _filterOptions.map((filter) {
                        bool isSelected = _selectedFilter == filter;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? primaryColor : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                      : null,
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
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
              ),
            ],
          ),
        ),

        // Search results information
        SizedBox(height: 10),

        // Houses listing
        filteredHouses.isEmpty
            ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.home_work_outlined,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Aucune propriété trouvée',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Essayez de changer vos filtres pour trouver plus de résultats',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
            : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredHouses.length,
              itemBuilder: (context, index) {
                final house = filteredHouses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Pass data to details screen
                      Navigator.pushNamed(
                        context,
                        '/house_details',
                        arguments: {
                          'imagePath': house['image'],
                          'contractType': house['contractType'],
                          'location': '${house['area']}, ${house['city']}',
                          'price': house['price'].toDouble(),
                          'bedrooms': house['bedrooms'],
                          'bathrooms': house['bathrooms'],
                          'kitchens': 1, // Assuming 1 kitchen per house
                          'description':
                              'Cette magnifique propriété située à ${house['area']} offre un cadre de vie exceptionnel avec ${house['bedrooms']} chambres et ${house['bathrooms']} salles de bain. Parfait pour une famille ou comme investissement immobilier.',
                          'propertyName': house['propertyName'],
                          'agentName': 'Ahmed Moussa',
                          'agentRole': 'Agent Immobilier Senior',
                          'agentImage': 'images/agent.jpg',
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                        children: [
                          // Property image with status tag
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.asset(
                                  house['image'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Status tag (new or contract type)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        house['isNew']
                                            ? Colors.green
                                            : (house['contractType'] == 'Vente'
                                                ? primaryColor
                                                : Colors.orange),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    house['isNew']
                                        ? 'Nouveau'
                                        : house['contractType'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              // Price tag
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        house['propertyName'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${_formatPrice(house['price'])} FCFA',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Property details
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Location
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: primaryColor,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '${house['area']}, ${house['city']}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                // Amenities
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildFeatureChip(
                                      Icons.king_bed_outlined,
                                      '${house['bedrooms']} Ch',
                                    ),
                                    SizedBox(width: 12),
                                    _buildFeatureChip(
                                      Icons.bathtub_outlined,
                                      '${house['bathrooms']} SdB',
                                    ),
                                    SizedBox(width: 12),
                                    if (!house['isNew'])
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              house['contractType'] == 'Vente'
                                                  ? primaryColor.withOpacity(
                                                    0.1,
                                                  )
                                                  : Colors.orange.withOpacity(
                                                    0.1,
                                                  ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          house['contractType'],
                                          style: TextStyle(
                                            color:
                                                house['contractType'] == 'Vente'
                                                    ? primaryColor
                                                    : Colors.orange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
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
                  ),
                );
              },
            ),

        // Add some bottom padding
        SizedBox(height: 20),
      ],
    );
  }

  // Helper method to build feature chips
  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Format price with commas as thousands separators
  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
