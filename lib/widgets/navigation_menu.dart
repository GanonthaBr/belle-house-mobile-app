import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/houses.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/icon_element.dart';
import 'package:mobile_app/widgets/menu_item.dart';
import 'package:mobile_app/widgets/search_bar.dart';
import 'package:mobile_app/widgets/title_text.dart';

class NaviMenu extends StatefulWidget {
  const NaviMenu({super.key});

  @override
  State<NaviMenu> createState() => _NaviMenuState();
}

class _NaviMenuState extends State<NaviMenu> {
  int currentpage = 0;
  final List _pages = [
    const HomeScreen(),
    const Houses(),
    const HomeScreen(),
    const Houses(),
  ];
  void onTapNav(int index) {
    setState(() {
      currentpage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Column(
        children: [
          //heading
          Container(
            margin: EdgeInsets.only(
              top: AppDimension.distance30 * 1.6,
              left: AppDimension.distance20 / 2,
              right: AppDimension.distance20 / 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //first component
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.primaryColor,
                    ),
                    TitleText(
                      text: 'Niamey',
                      fontSize: AppDimension.radius8 * 2,
                      color: AppColors.primaryColor,
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
                Center(
                  child: IconElement(
                    radius: AppDimension.distance20 / 2,
                    size: AppDimension.distance30,
                    bgColor: AppColors.secondaryColor,
                    icon: Icons.notifications,
                    color: AppColors.primaryColor,
                    height: AppDimension.distance45,
                  ),
                ),
                //second component
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimension.distance20 / 4),
                //search bar
                Row(
                  children: [
                    // search bar
                    Expanded(
                      flex: (AppDimension.distance20 / 4).toInt(),
                      child: TextFielSearch(
                        controller: TextEditingController(),
                        onChanged: (value) {},
                      ),
                    ),
                    SizedBox(width: AppDimension.distance20 / 2),
                    // filter icon
                    Expanded(
                      flex: 1,
                      child: IconElement(
                        radius: AppDimension.distance20 / 2,
                        size: AppDimension.distance30,
                        bgColor: AppColors.secondaryColor,
                        icon: Icons.filter_list,
                        color: AppColors.primaryColor,
                        height: AppDimension.distance45,
                      ),
                    ),
                  ],
                ),
                //navigation menu
                SizedBox(height: AppDimension.distance20 / 4),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: AppDimension.distance20 / 2,
                      ),
                      child: TitleText(
                        text: 'CATEGORIES',
                        fontSize: AppDimension.radius14,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimension.distance20 / 4),
                //menu items
                Padding(
                  padding: EdgeInsets.only(left: AppDimension.distance20 / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MenuItem(
                        action: () {
                          currentpage = 0;
                          onTapNav(currentpage);
                        },
                        title: 'Accueil',
                        icon: Icons.apartment,
                        iconColor:
                            currentpage == 0
                                ? AppColors.secondaryColor
                                : AppColors.primaryColor,
                        color:
                            currentpage == 0
                                ? AppColors.secondaryColor
                                : AppColors.primaryColor,
                        bgColor:
                            currentpage == 0
                                ? AppColors.primaryColor
                                : AppColors.secondaryColor,
                      ),
                      MenuItem(
                        action: () {
                          currentpage = 1;
                          onTapNav(currentpage);
                        },
                        title: 'Maisons',
                        icon: Icons.house,
                        iconColor:
                            currentpage == 1
                                ? AppColors.secondaryColor
                                : AppColors.primaryColor,
                        color:
                            currentpage == 1
                                ? AppColors.secondaryColor
                                : AppColors.primaryColor,
                        bgColor:
                            currentpage == 1
                                ? AppColors.primaryColor
                                : AppColors.secondaryColor,
                      ),
                      MenuItem(
                        action: () {
                          currentpage = 2;
                          onTapNav(currentpage);
                        },
                        title: 'Parcelles',
                        icon: Icons.landscape,
                        iconColor:
                            currentpage == 2
                                ? AppColors.secondaryColor
                                : AppColors.primaryColor,
                        color:
                            currentpage == 2
                                ? AppColors.secondaryColor
                                : AppColors.primaryColor,
                        bgColor:
                            currentpage == 2
                                ? AppColors.primaryColor
                                : AppColors.secondaryColor,
                      ),
                      MenuItem(
                        action: () {
                          currentpage = 3;
                          onTapNav(currentpage);
                        },
                        title: 'Shopping',
                        icon: Icons.shopify_sharp,
                        iconColor:
                            currentpage == 3
                                ? AppColors.secondaryColor
                                : AppColors.primaryColor,
                        color:
                            currentpage == 3
                                ? AppColors.secondaryColor
                                : AppColors.primaryColor,
                        bgColor:
                            currentpage == 3
                                ? AppColors.primaryColor
                                : AppColors.secondaryColor,
                      ),
                      // MenuItem(
                      //   title: 'Autres',
                      //   color: AppColors.iconColor1,
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimension.distance20 / 4),
                //house list
                // const Houses()
                // FurnitureList()
                _pages[currentpage],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
