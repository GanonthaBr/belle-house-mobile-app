import 'package:flutter/material.dart';
import 'package:mobile_app/providers/favorites_provider.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TitleText(
          text: 'Mes Sauvegardes',
          color: AppColors.secondaryColor,
          fontSize: AppDimension.fontSize24,
        ),
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: AppDimension.distance50 * 2,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoriteProvider, child) {
              final favorites = favoriteProvider.favoritesInfos;
              final totalFavoritesCount = favorites?['total_count'] ?? 0;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total count badge
                  if (totalFavoritesCount > 0)
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$totalFavoritesCount',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // Refresh button
                  IconButton(
                    icon:
                        favoriteProvider.isLoading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.secondaryColor,
                              ),
                            )
                            : Icon(
                              Icons.refresh,
                              color: AppColors.secondaryColor,
                            ),
                    onPressed:
                        favoriteProvider.isLoading
                            ? null
                            : () async {
                              await favoriteProvider.getFavorites();
                            },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoriteProvider, child) {
          // Loading state
          if (favoriteProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryColor),
                  SizedBox(height: 16),
                  TitleText(
                    text: 'Chargement des favoris...',
                    color: AppColors.primaryColor,
                    fontSize: AppDimension.fontSize18,
                  ),
                ],
              ),
            );
          }

          // Error state
          if (favoriteProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimension.distance20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.red),
                    SizedBox(height: 16),
                    TitleText(
                      text: 'Erreur',
                      color: AppColors.red,
                      fontSize: AppDimension.fontSize18,
                    ),
                    SizedBox(height: 8),
                    Text(
                      favoriteProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.red),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        favoriteProvider.getFavorites();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Get favorites data
          final favoritesByType = favoriteProvider.favoritesInfos;
          final totalCount = favoritesByType?['total_count'];

          // print("📦 Favorites by type: $favoritesByType");
          // print("📊 Total count: $totalCount");
          // print("FAV: ${favoritesByType?['favorites']['houses']}");
          // Empty state
          if (totalCount == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppColors.primaryColorLoose,
                  ),
                  SizedBox(height: 24),
                  TitleText(
                    text: 'Aucun favori',
                    color: AppColors.primaryColor,
                    fontSize: AppDimension.fontSize24,
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.distance20 * 2,
                    ),
                    child: Text(
                      'Vous n\'avez pas encore ajouté d\'éléments à vos favoris. Explorez nos biens et ajoutez ceux qui vous intéressent !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryColorLoose,
                        fontSize: AppDimension.fontSize18,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to home or explore
                      DefaultTabController.of(
                        context,
                      ).animateTo(0); // Go to home tab
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimension.distance20 * 2,
                        vertical: AppDimension.distance20 / 2,
                      ),
                    ),
                    child: Text(
                      'Explorer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          if (favoritesByType == null) {
            return Center(child: Text('Votre liste de Favoris est vide!'));
          }
          // Display favorites grouped by type
          return ListView(
            padding: EdgeInsets.all(AppDimension.distance20 / 2),
            children: [
              // Houses section
              if (favoritesByType['favorites'].containsKey('houses') &&
                  favoritesByType['favorites']['houses']!.isNotEmpty)
                _buildFavoriteSection(
                  'Maisons',
                  favoritesByType['favorites']['houses']!,
                  Icons.home_rounded,
                  favoriteProvider,
                ),

              // Lands section
              if (favoritesByType['favorites'].containsKey('lands') &&
                  favoritesByType['favorites']['lands']!.isNotEmpty)
                _buildFavoriteSection(
                  'Terrains',
                  favoritesByType['favorites']['lands']!,
                  Icons.landscape_rounded,
                  favoriteProvider,
                ),

              // Products section
              if (favoritesByType['favorites'].containsKey('products') &&
                  favoritesByType['favorites']['products']!.isNotEmpty)
                _buildFavoriteSection(
                  'Produits',
                  favoritesByType['favorites']['products']!,
                  Icons.shopping_bag_rounded,
                  favoriteProvider,
                ),

              // Add spacing at the bottom
              SizedBox(height: AppDimension.distance20 * 2),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFavoriteSection(
    String title,
    List favorites,
    IconData icon,
    FavoritesProvider favoriteProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimension.distance20 / 2,
            vertical: AppDimension.distance20 / 2,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimension.radius8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimension.radius8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: AppDimension.distance20,
                ),
              ),
              SizedBox(width: AppDimension.distance20 / 2),
              TitleText(
                text: title,
                color: AppColors.primaryColor,
                fontSize: AppDimension.fontSize24,
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimension.radius8,
                  vertical: AppDimension.radius8 / 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(AppDimension.radius8),
                ),
                child: Text(
                  '${favorites.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimension.fontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Favorites list
        ...favorites.map(
          (favorite) => FavoriteItem(
            favorite: favorite,
            onDelete: () async {
              await favoriteProvider.removeFavorite(
                contentTypeId: favorite['content_type_id'],
                objectId: favorite['object_id'],
              );
            },
          ),
        ),

        SizedBox(height: AppDimension.distance20),
      ],
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final Map<String, dynamic> favorite;
  final VoidCallback onDelete;

  const FavoriteItem({
    super.key,
    required this.favorite,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Extract data from API response
    final objectData = favorite['object_data'] ?? {};
    final String name = objectData['name'] ?? 'Nom non disponible';
    final String area = objectData['area'] ?? 'Zone non spécifiée';
    final String agentName = objectData['agentName'] ?? 'Agent non spécifié';
    final double price = (objectData['price'] ?? 0.0).toDouble();
    final String createdAt = favorite['created_at'] ?? '';
    final List images = objectData['more_images'] ?? '';

    // Format date
    String formattedDate = 'Date inconnue';
    if (createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        // Keep default value
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimension.distance20 / 2,
        vertical: AppDimension.distance20 / 4,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primaryColorLoose),
          borderRadius: BorderRadius.circular(AppDimension.distance20 / 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColorLoose.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Main content
            SizedBox(
              height: AppDimension.screenHeight / 7,
              child: Row(
                children: [
                  // Image section
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(AppDimension.radius8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimension.radius8,
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              images.isNotEmpty
                                  ? NetworkImage(
                                    "http://data.bellehouseniger.com${images.first}",
                                  )
                                  : AssetImage('images/BH39.jpg'),
                        ),
                      ),
                    ),
                  ),

                  // Content section
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(AppDimension.radius8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Name
                          TitleText(
                            text: name,
                            color: AppColors.black,
                            fontSize: AppDimension.fontSize18,
                          ),

                          // Location
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColors.primaryColor,
                                size: AppDimension.fontSize18,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: TitleText(
                                  text: area,
                                  color: AppColors.black,
                                  fontSize: AppDimension.distance45 / 3,
                                ),
                              ),
                            ],
                          ),

                          // Agent
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: AppColors.primaryColor,
                                size: AppDimension.distance5 * 3,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: TitleText(
                                  text: agentName,
                                  color: AppColors.primaryColorLoose,
                                  fontSize: AppDimension.distance20 / 2,
                                ),
                              ),
                            ],
                          ),

                          // Price
                          TitleText(
                            text: "${price.toStringAsFixed(0)} FCFA",
                            color: AppColors.primaryColor,
                            fontSize: AppDimension.distance30 / 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom section with date and actions
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimension.distance20 / 2,
                vertical: AppDimension.distance20 / 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.gray.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimension.distance20 / 2),
                  bottomRight: Radius.circular(AppDimension.distance20 / 2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: AppDimension.distance30 / 2,
                    color: AppColors.primaryColorLoose,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Ajouté le $formattedDate',
                    style: TextStyle(
                      color: AppColors.primaryColorLoose,
                      fontSize: AppDimension.distance20 / 2,
                    ),
                  ),
                  Spacer(),

                  // Delete button
                  Consumer<FavoritesProvider>(
                    builder: (context, provider, child) {
                      final isLoading = provider.isItemLoading(
                        favorite['content_type_id'],
                        favorite['object_id'],
                      );

                      return GestureDetector(
                        onTap:
                            isLoading
                                ? null
                                : () async {
                                  // Show confirmation dialog
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text(
                                            'Confirmer la suppression',
                                          ),
                                          content: Text(
                                            'Voulez-vous vraiment supprimer cet élément de vos favoris ?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                              child: Text('Annuler'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    context,
                                                  ).pop(true),
                                              child: Text(
                                                'Supprimer',
                                                style: TextStyle(
                                                  color: AppColors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );

                                  if (shouldDelete == true) {
                                    onDelete();
                                  }
                                },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimension.radius8,
                            vertical: AppDimension.radius8 / 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimension.radius8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isLoading)
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: AppColors.red,
                                  ),
                                )
                              else
                                Icon(
                                  Icons.delete_outline,
                                  color: AppColors.red,
                                  size: AppDimension.distance30 / 2,
                                ),
                              SizedBox(width: 4),
                              Text(
                                'Supprimer',
                                style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: AppDimension.distance30 / 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
