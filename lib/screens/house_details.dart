import 'package:flutter/material.dart';
import 'package:mobile_app/models/houses_model.dart';
import 'package:mobile_app/providers/favorites_provider.dart';
import 'package:mobile_app/widgets/descrption_text.dart';
import 'package:mobile_app/widgets/image_gallery.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_app/utils/content_types.dart';

class HouseDetailsScreen extends StatefulWidget {
  final Property
  property; // Use the Property object instead of individual parameters

  const HouseDetailsScreen({super.key, required this.property});

  @override
  State<HouseDetailsScreen> createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<HouseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final favoriteProvider = Provider.of<FavoritesProvider>(
        context,
        listen: false,
      );

      //
      await favoriteProvider.getFavorites();
    });
  }

  bool isFavorite = false;
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    // Define colors
    const Color primaryColor = Color(0xff61a1d6);
    const Color secondaryColor = Colors.white;

    // Get all images
    final List<String> allImages = widget.property.allImages;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<FavoritesProvider>(
        builder: (context, favoriteProvider, child) {
          final isFavorited = favoriteProvider.isFavorited(
            ContentType.property.id,
            widget.property.id,
          );
          // print("IS IT: $isFavorited");
          // final isItemLoading = favoriteProvider.isItemLoading(
          //   ContentType.property.id,
          //   widget.property.id,
          // );

          return SafeArea(
            child: Stack(
              children: [
                // Content scrolling area
                CustomScrollView(
                  slivers: [
                    // Property image gallery and top buttons
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          // Image Gallery
                          Container(
                            height: height * 0.4,
                            width: width,
                            child:
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
                                            return Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    allImages[index],
                                                  ),
                                                  fit: BoxFit.cover,
                                                  onError: (
                                                    exception,
                                                    stackTrace,
                                                  ) {
                                                    // Handle image loading error
                                                  },
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                    25,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    25,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // Image indicators
                                        if (allImages.length > 1)
                                          Positioned(
                                            bottom: 20,
                                            left: 0,
                                            right: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                        _currentImageIndex ==
                                                                index
                                                            ? secondaryColor
                                                            : secondaryColor
                                                                .withOpacity(
                                                                  0.5,
                                                                ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        // Image counter
                                        if (allImages.length > 1)
                                          Positioned(
                                            bottom: 45,
                                            right: 20,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.6,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                '${_currentImageIndex + 1}/${allImages.length}',
                                                style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    )
                                    : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.home,
                                          size: 64,
                                          color: Colors.grey[600],
                                        ),
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
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: secondaryColor,
                                ),
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
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      isFavorited ? Colors.red : secondaryColor,
                                ),
                                onPressed: () async {
                                  await favoriteProvider.toggleFavorite(
                                    contentTypeId: ContentType.property.id,
                                    objectId: widget.property.id,
                                    itemName: widget.property.name,
                                  );
                                },
                              ),
                            ),
                          ),
                          // Gallery button (if more than one image)
                          if (allImages.length > 1)
                            Positioned(
                              top: height * 0.02,
                              right: width * 0.2,
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                radius: 20,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.photo_library,
                                    color: secondaryColor,
                                  ),
                                  onPressed:
                                      () =>
                                          _showImageGallery(context, allImages),
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
                          // Contract type tag
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
                                Icon(
                                  Icons.assignment,
                                  color: primaryColor,
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  widget.property.contractType.toUpperCase(),
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Property name (if available)
                          if (widget.property.name.isNotEmpty) ...[
                            Text(
                              widget.property.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],

                          // Location and price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: primaryColor,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        widget.property.location,
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
                                '${widget.property.price.toStringAsFixed(2)}FCFA',
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
                                _buildFeatureItem(
                                  Icons.king_bed_outlined,
                                  '${widget.property.bedrooms}',
                                  'Bedrooms',
                                ),
                                _buildVerticalDivider(),
                                _buildFeatureItem(
                                  Icons.bathtub_outlined,
                                  '${widget.property.bathrooms}',
                                  'Bathrooms',
                                ),
                                _buildVerticalDivider(),
                                _buildFeatureItem(
                                  Icons.kitchen_outlined,
                                  '${widget.property.kitchens}',
                                  'Kitchens',
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: height * 0.03),

                          // Image gallery section (if more images exist)
                          if (widget.property.moreImages.isNotEmpty) ...[
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
                                      () =>
                                          _showImageGallery(context, allImages),
                                  child: Text('View All (${allImages.length})'),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.015),
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '+${allImages.length - 3}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            SizedBox(height: height * 0.03),
                          ],

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
                                widget.property.description.isNotEmpty
                                    ? widget.property.description
                                    : 'No description available.',
                          ),

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
                                  backgroundColor: primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: primaryColor,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.property.agentName.isNotEmpty
                                            ? widget.property.agentName
                                            : 'Property Agent',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Real Estate Agent',
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
                            onPressed:
                                () => _showContactDialog(context, 'call'),
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
                                Text('Appeler'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                () => _showContactDialog(context, 'message'),
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
          );
        },
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

  // Helper method to build vertical dividers between features
  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[300]);
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

  // Method to show contact dialog based on action type
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
                  widget.property.agentName.isNotEmpty
                      ? widget.property.agentName
                      : 'Property Agent',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  actionType == 'Appeler'
                      ? 'Appeler le démarcheur'
                      : 'Message Agent',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                actionType == 'Appeler'
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
                        child: Text(
                          actionType == 'Appeler'
                              ? 'Appeler Maintenant'
                              : 'Envoyer',
                        ),
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
