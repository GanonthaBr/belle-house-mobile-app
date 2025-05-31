import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/widgets/descrption_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HouseDetailsScreen extends StatefulWidget {
  final String imagePath;
  final String contractType;
  final String location;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final int kitchens;
  final String description;
  final String agentName;
  final String agentRole;
  final String agentImage;

  const HouseDetailsScreen({
    Key? key,
    required this.imagePath,
    required this.contractType,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.kitchens,
    required this.description,
    required this.agentName,
    required this.agentRole,
    required this.agentImage,
  }) : super(key: key);

  @override
  State<HouseDetailsScreen> createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<HouseDetailsScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    // Define colors
    const Color primaryColor = Color(0xff61a1d6);
    const Color secondaryColor = Colors.white;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            // Content scrolling area
            CustomScrollView(
              slivers: [
                // Property image and top back button
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      // Property Image
                      Container(
                        height: height * 0.4,
                        width: width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.imagePath),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                      ),
                      // Back button
                      Positioned(
                        top: height * 0.02,
                        left: width * 0.05,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          radius: 20,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: secondaryColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      // Favorite button (replacing property tag)
                      Positioned(
                        top: height * 0.02,
                        right: width * 0.05,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          radius: 20,
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : secondaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Property details section
                SliverPadding(
                  padding: EdgeInsets.all(width * 0.05),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Contract type tag (moved from top right)
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          // color: primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: width * 0.25,
                        child: Row(
                          children: [
                            Text(
                              widget.contractType,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Location and price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.location_on, color: primaryColor),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    widget.location,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${widget.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.02),

                      // Property features
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFeatureItem(
                              Icons.king_bed_outlined,
                              '${widget.bedrooms}',
                              'Bedrooms',
                            ),
                            _buildVerticalDivider(),
                            _buildFeatureItem(
                              Icons.bathtub_outlined,
                              '${widget.bathrooms}',
                              'Bathrooms',
                            ),
                            _buildVerticalDivider(),
                            _buildFeatureItem(
                              Icons.kitchen_outlined,
                              '${widget.kitchens}',
                              'Kitchens',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      // Description header
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: height * 0.015),

                      // Description text
                      DescriptionText(text: widget.description),

                      SizedBox(height: height * 0.03),

                      // Agent information
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(widget.agentImage),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.agentName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    widget.agentRole,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Add extra space for bottom buttons
                      SizedBox(height: height * 0.1),
                    ]),
                  ),
                ),
              ],
            ),

            // Bottom contact buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showContactDialog(context, 'call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.call, size: 20),
                            SizedBox(width: 8),
                            Text('Call'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showContactDialog(context, 'message'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: secondaryColor,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.message, size: 20),
                            SizedBox(width: 8),
                            Text('Message'),
                          ],
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

  // Helper method to build feature items (bedrooms, bathrooms, kitchens)
  Widget _buildFeatureItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Color(0xff61a1d6), size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  // Helper method to build vertical dividers between features
  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[300]);
  }

  // Method to show contact dialog based on action type
  void _showContactDialog(BuildContext context, String actionType) {
    final phoneNumber =
        '+1234567890'; // Example phone number, replace with real one from your data

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(widget.agentImage),
                ),
                SizedBox(height: 15),
                Text(
                  widget.agentName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  actionType == 'call' ? 'Call Agent' : 'Message Agent',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                actionType == 'call'
                    ? Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                    : Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Write your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (actionType == 'call') {
                            _makePhoneCall(phoneNumber);
                          } else {
                            _sendMessage(phoneNumber);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff61a1d6),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(actionType == 'call' ? 'Call Now' : 'Send'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  // Method to send a message
  Future<void> _sendMessage(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'sms', path: phoneNumber);
    await launchUrl(launchUri);
  }
}
