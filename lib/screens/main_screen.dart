import 'package:flutter/material.dart';
import 'package:mobile_app/screens/my_screen.dart';
import 'package:mobile_app/screens/profileScreen.dart';
import 'package:mobile_app/screens/conversations_screen.dart';
import 'package:mobile_app/screens/favorites_screen.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/navigation_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    MyScreen(),
    const FavoritesScreen(),
    ConversationsScreen(),
    ProfileScreen(),
  ];
  //changing the screen on tapping
  void onTapNav(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: IndexedStack(index: _currentIndex, children: _pages),
      // appBar: AppBar(toolbarHeight: 10),
      bottomNavigationBar: Container(
        height: AppDimension.distance70 * 2,
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimension.distance20 / 2),
            topRight: Radius.circular(AppDimension.distance20 / 2),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimension.radius14),
            topRight: Radius.circular(AppDimension.radius14),
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.secondaryColor,
            selectedItemColor: AppColors.deepGray,
            onTap: onTapNav,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: AppColors.deepGray,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.home, 0),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.favorite, 1),
                label: 'Favoris',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.chat, 2),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.person, 3),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return Container(
      height: AppDimension.fontSize18 * 2,
      width: AppDimension.fontSize18 * 4,
      decoration: BoxDecoration(
        color:
            _currentIndex == index
                ? AppColors.primaryColorLoose
                : null, // Change the color based on the selected index
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, size: AppDimension.distance30),
    );
  }
}


//  const HouseDetailsScreen(
//       imagePath: 'images/BH39.jpg',
//       contractType: 'Location',
//       location: 'Francophonie',
//       price: 20000.00,
//       bedrooms: 2,
//       bathrooms: 2,
//       kitchens: 1,
//       description: 'Maison',
//       agentRole: 'Agennce Immobilier',
//       agentName: 'Belle House',
//       agentImage: 'images/logo.png',
//     ),