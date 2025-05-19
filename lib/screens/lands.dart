import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';

class ParcelleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> parcelle;

  const ParcelleDetailScreen({Key? key, required this.parcelle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(parcelle['name']),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(bottom: height / 42), // 20 = height/42
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  height: height / 3.36, // 250 = height/3.36
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/BH39.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Details
                Padding(
                  padding: EdgeInsets.all(height / 52.5), // 16 = height/52.5
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parcelle['name'],
                        style: TextStyle(
                          fontSize: height / 35, // 24 = height/35
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height / 105), // 8 = height/105
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          SizedBox(width: height / 105), // 8 = height/105
                          Text(
                            parcelle['location'],
                            style: TextStyle(
                              fontSize: height / 52.5, // 16 = height/52.5
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 30),
                      // Price and size
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoCard(
                            context,
                            Icons.straighten,
                            parcelle['size'],
                            'Superficie',
                          ),
                          _buildInfoCard(
                            context,
                            Icons.monetization_on,
                            '${parcelle['price']} FCFA',
                            'Prix',
                          ),
                        ],
                      ),

                      SizedBox(height: height / 25),
                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: height / 42, // 18 = height/42
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height / 105), // 8 = height/105
                      Text(
                        'Cette parcelle est située dans une zone résidentielle calme avec un accès facile aux routes principales. Le terrain est plat et prêt pour la construction. Tous les documents administratifs sont disponibles et à jour.',
                        style: TextStyle(
                          fontSize: height / 52.5,
                          height: 1.5,
                        ), // 16 = height/52.5
                      ),

                      SizedBox(height: height / 17.5), // 24 = height/17.5
                      // Contact Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Contact action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: height / 50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                height / 52.5,
                              ), // 10 = height/52.5
                            ),
                          ),
                          child: Text(
                            'Contacter le vendeur',
                            style: TextStyle(
                              fontSize: height / 52.5, // 16 = height/52.5
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height / 84), // 10 = height/84
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            // Save action
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primaryColor),
                            padding: EdgeInsets.symmetric(
                              vertical: height / 50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                height / 52.5,
                              ), // 10 = height/52.5
                            ),
                          ),
                          child: Text(
                            'Sauvegarder',
                            style: TextStyle(
                              fontSize: height / 52.5, // 16 = height/52.5
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
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
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: height / 40),
          child: Column(
            children: [
              Icon(
                icon,
                size: height / 28,
                color: AppColors.primaryColor,
              ), // 30 = height/28
              SizedBox(height: height / 105), // 8 = height/105
              Text(
                value,
                style: TextStyle(
                  fontSize: height / 52.5,
                  fontWeight: FontWeight.bold,
                ), // 16 = height/52.5
              ),
              SizedBox(height: height / 210), // 4 = height/210
              Text(
                label,
                style: TextStyle(
                  fontSize: height / 60,
                  color: Colors.grey[600],
                ), // 14 = height/60
              ),
            ],
          ),
        ),
      ),
    );
  }
}
