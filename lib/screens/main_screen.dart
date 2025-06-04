import 'package:flutter/material.dart';
import 'package:mobile_app/screens/my_screen.dart';
import 'package:mobile_app/screens/profileScreen.dart';
import 'package:mobile_app/screens/conversations_screen.dart';
import 'package:mobile_app/screens/favorites_screen.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late PageController _pageController;

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.chat_bubble_rounded,
    Icons.person_rounded,
  ];

  final List<String> _labels = ['Accueil', 'Favoris', 'Messages', 'Profile'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void onTapNav(int index) {
    // Don't animate if same tab is pressed
    if (_currentIndex == index) return;

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    setState(() {
      _currentIndex = index;
    });

    // Animate to the selected page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Handle page changes from swipe gestures (if you want to enable them)
  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        // Set to NeverScrollableScrollPhysics() if you don't want swipe navigation
        physics: const ClampingScrollPhysics(), // Allow swipe navigation
        children: [
          MyScreen(),
          FavoritesScreen(),
          ConversationsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(),
        padding: EdgeInsets.only(top: AppDimension.distance20 / 2),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(AppDimension.distance30),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimension.distance30),
          child: Container(
            height: AppDimension.distance70 * 2,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimension.distance20 / 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_icons.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTapNav(index),
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              _currentIndex == index
                                  ? _scaleAnimation.value
                                  : 1.0,
                          child: _buildNavItem(
                            _icons[index],
                            _labels[index],
                            index,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      padding: EdgeInsets.symmetric(
        vertical: AppDimension.distance20 / 2,
        horizontal: AppDimension.distance5,
      ),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppColors.secondaryColor.withOpacity(0.2)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimension.distance20),
        border:
            isSelected
                ? Border.all(
                  color: AppColors.secondaryColor.withOpacity(0.3),
                  width: 1,
                )
                : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            padding: EdgeInsets.all(AppDimension.distance5),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: AppColors.secondaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : null,
            ),
            child: Icon(
              icon,
              size: AppDimension.distance20 + 2,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppDimension.distance5 / 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: AppDimension.distance20 / 1.3,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: AppColors.secondaryColor,
              letterSpacing: 0.5,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
