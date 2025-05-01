import 'package:flutter/material.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/providers/generic_provider.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AuthProvider>(context, listen: false).fetchUserInfo();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final countryCity = await authProvider.getCountryAndCity();
      print("Country: ${countryCity['country']}");
      print("City: ${countryCity['city']}");
    });
  }

  Future<void> logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
  }

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
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          final userInfo = authProvider.userInfo;
          // final country_city = authProvider.getCountryAndCity();

          print(userInfo);
          // print("Your Country: ${country_city}");

          if (userInfo == null) {
            return Center(
              child: Text(
                'Failed to load user information.',
                style: TextStyle(
                  fontSize: AppDimension.fontSize18,
                  color: AppColors.primaryColor,
                ),
              ),
            );
          }
          return SingleChildScrollView(
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
                          backgroundImage: AssetImage(
                            userInfo['profile_picture'].toString(),
                          ),
                        ),
                        SizedBox(height: AppDimension.distance20),
                        Text(
                          userInfo['username'] ?? 'Unknown Name',
                          style: TextStyle(
                            fontSize: AppDimension.fontSize24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: AppDimension.distance20 / 2),
                        Text(
                          userInfo['email'] ?? 'No email',
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
                      userInfo['phone_number'] ?? 'No phone added',
                      style: TextStyle(
                        fontSize: AppDimension.fontSize18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: AppColors.primaryColor,
                    ),
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
                      userInfo['created_at'] ?? '',
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
                    leading: Icon(
                      Icons.favorite,
                      color: AppColors.primaryColor,
                    ),
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
                      onPressed: () async {
                        // Logout action
                        await logout();
                        Navigator.pushReplacementNamed(context, '/login');
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
          );
        },
      ),
    );
  }
}
