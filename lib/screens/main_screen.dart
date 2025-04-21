import 'package:flutter/material.dart';
import 'package:mobile_app/screens/house_details.dart';
import 'package:mobile_app/screens/register_screen.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/navigation_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  List pages = [
    const NaviMenu(),
    const HouseDetailsScreen(),
    const RegisterScreen(),
    const RegisterScreen(),
  ];
  //changing the screen on tapping
  void onTapNav(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        height: AppDimension.distance70,
        decoration: const BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.secondaryColor,
            selectedItemColor: AppColors.deepGray,
            onTap: onTapNav,
            currentIndex: currentIndex,
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
            currentIndex == index
                ? AppColors.primaryColorLoose
                : null, // Change the color based on the selected index
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, size: AppDimension.distance30),
    );
  }
}
