import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/title_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: AppDimension.distance50 * 2,
        backgroundColor: AppColors.primaryColor,
        title: TitleText(
          text: 'Profile',
          fontSize: AppDimension.fontSize18 * 2,
          color: AppColors.secondaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimension.distance20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: AppDimension.distance50,
                      backgroundImage: AssetImage('images/logo.png'),
                    ),
                    SizedBox(height: AppDimension.distance20),
                    Text(
                      'Ali Mohamed',
                      style: TextStyle(
                        fontSize: AppDimension.fontSize24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: AppDimension.distance20 / 2),
                    Text(
                      'mohali@example.com',
                      style: TextStyle(
                        fontSize: AppDimension.fontSize18,
                        color: AppColors.primaryColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimension.distance30),

              // Account Details Section
              Text(
                'Details du Compte',
                style: TextStyle(
                  fontSize: AppDimension.fontSize18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: AppDimension.distance20),
              ListTile(
                leading: Icon(Icons.phone, color: AppColors.primaryColor),
                title: Text(
                  '+227 22 34 67 90',
                  style: TextStyle(
                    fontSize: AppDimension.fontSize18,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: AppColors.primaryColor),
                title: Text(
                  '123 Main Street, City, Country',
                  style: TextStyle(
                    fontSize: AppDimension.fontSize18,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  'Member since: January 2023',
                  style: TextStyle(
                    fontSize: AppDimension.fontSize18,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: AppDimension.distance30),

              // App Info Section
              Text(
                'App Information',
                style: TextStyle(
                  fontSize: AppDimension.fontSize18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: AppDimension.distance20),
              // ListTile(
              //   leading: Icon(Icons.home, color: AppColors.primaryColor),
              //   title: Text(
              //     'Properties Listed: 12',
              //     style: TextStyle(
              //       fontSize: AppDimension.fontSize18,
              //       color: AppColors.primaryColor,
              //     ),
              //   ),
              // ),
              ListTile(
                leading: Icon(Icons.favorite, color: AppColors.primaryColor),
                title: Text(
                  'Favorites: 8',
                  style: TextStyle(
                    fontSize: AppDimension.fontSize18,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              // ListTile(
              //   leading: Icon(Icons.chat, color: AppColors.primaryColor),
              //   title: Text(
              //     'Messages: 5',
              //     style: TextStyle(
              //       fontSize: AppDimension.fontSize18,
              //       color: AppColors.primaryColor,
              //     ),
              //   ),
              // ),
              SizedBox(height: AppDimension.distance30),

              // Logout Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logout action
                  },
                  icon: Icon(Icons.logout, color: AppColors.secondaryColor),
                  label: Text(
                    'Deconnexion',
                    style: TextStyle(
                      fontSize: AppDimension.fontSize18,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.distance30,
                      vertical: AppDimension.distance20 / 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimension.radius14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
