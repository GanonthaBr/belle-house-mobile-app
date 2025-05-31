import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/widgets/descrption_text.dart';
import 'package:url_launcher/url_launcher.dart';

class LandDetailsScreen extends StatefulWidget {
  final String imagePath;
  final String name;
  final String location;
  final double price;
  final double size;
  final String landType;
  final String description;
  final String ownerName;

  const LandDetailsScreen({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.location,
    required this.price,
    required this.size,
    required this.landType,
    required this.description,
    required this.ownerName,
  }) : super(key: key);

  @override
  State<LandDetailsScreen> createState() => _LandDetailsScreenState();
}

class _LandDetailsScreenState extends State<LandDetailsScreen> {
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
                // Land image and top back button
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      // Land Image
                      Container(
                        height: height * 0.4,
                        width: width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.imagePath),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              // Handle image loading error
                            },
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child:
                            widget.imagePath.isEmpty
                                ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.landscape,
                                      size: 64,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                )
                                : null,
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
                      // Favorite button
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

                // Land details section
                SliverPadding(
                  padding: EdgeInsets.all(width * 0.05),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Land type tag
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primaryColor),
                        ),
                        width: width * 0.3,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.terrain, color: primaryColor, size: 16),
                            SizedBox(width: 5),
                            Text(
                              widget.landType.toUpperCase(),
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Land name
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: 10),

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
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${widget.price.toStringAsFixed(2)} FCFA',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.02),

                      // Land specifications
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 15,
                        ),
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
                            _buildSpecificationItem(
                              Icons.square_foot,
                              '${widget.size.toStringAsFixed(0)}m²',
                              'Superficie',
                            ),
                            _buildVerticalDivider(),
                            _buildSpecificationItem(
                              Icons.landscape,
                              widget.landType,
                              'Type',
                            ),
                            _buildVerticalDivider(),
                            _buildSpecificationItem(
                              Icons.calculate,
                              '${(widget.price / widget.size).toStringAsFixed(2)} FCFA',
                              'Prix/m²',
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
                      DescriptionText(
                        text:
                            widget.description.isNotEmpty
                                ? widget.description
                                : 'Pas de description.',
                      ),

                      SizedBox(height: height * 0.03),

                      // Owner information
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
                              backgroundColor: primaryColor.withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                color: primaryColor,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.ownerName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Nom du vendeur',
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

  // Helper method to build specification items
  Widget _buildSpecificationItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Color(0xff61a1d6), size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper method to build vertical dividers
  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[300]);
  }

  // Method to show contact dialog
  void _showContactDialog(BuildContext context, String actionType) {
    final phoneNumber = '+1234567890'; // Default phone number

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
                  backgroundColor: Color(0xff61a1d6).withOpacity(0.1),
                  child: Icon(Icons.person, color: Color(0xff61a1d6), size: 30),
                ),
                SizedBox(height: 15),
                Text(
                  widget.ownerName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  actionType == 'call' ? 'Call Owner' : 'Message Owner',
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
