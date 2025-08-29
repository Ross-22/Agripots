import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/farmer.dart';
import 'cart_screen.dart';

// Category model class
class _CategoryItem {
  final IconData icon;
  final String label;

  const _CategoryItem({required this.icon, required this.label});
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Helper method to get responsive size
  double _getResponsiveSize(double size, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Base width is 375 (iPhone 12 Pro width)
    return size * (width / 375.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriPots'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // Navigate to cart screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      // Remove any bottom navigation bar from here
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveSize(16, context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting and Profile
                  Padding(
                    padding: EdgeInsets.only(
                      top: _getResponsiveSize(16.0, context),
                      bottom: _getResponsiveSize(16.0, context),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, User!',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontSize: _getResponsiveSize(
                                        20.0,
                                        context,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(
                                height: _getResponsiveSize(4.0, context),
                              ),
                              Text(
                                'What would you like to order today?',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: _getResponsiveSize(
                                        14.0,
                                        context,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: _getResponsiveSize(8.0, context)),
                        CircleAvatar(
                          radius: _getResponsiveSize(24.0, context),
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: _getResponsiveSize(24.0, context),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Bar
                  _buildSearchBar(context),

                  // Categories Section
                  _buildSectionTitle('Categories', context: context),
                  _buildCategories(context),

                  // Featured Products
                  _buildSectionTitle('Featured Harvest', context: context),
                  _buildFeaturedProducts(context),

                  // Nearby Farmers
                  _buildSectionTitle('Farmers Near You', context: context),
                  _buildNearbyFarmers(context),

                  SizedBox(height: _getResponsiveSize(16, context)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _getResponsiveSize(16, context)),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for products...',
          prefixIcon: Icon(Icons.search, size: _getResponsiveSize(20, context)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(
            vertical: _getResponsiveSize(12, context),
            horizontal: _getResponsiveSize(16, context),
          ),
        ),
        style: TextStyle(fontSize: _getResponsiveSize(14, context)),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _getResponsiveSize(8, context)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: _getResponsiveSize(18, context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      _CategoryItem(icon: Icons.eco, label: 'Vegetables'),
      _CategoryItem(icon: Icons.apple, label: 'Fruits'),
      _CategoryItem(icon: Icons.local_drink, label: 'Juices'),
      _CategoryItem(icon: Icons.egg, label: 'Eggs'),
      _CategoryItem(icon: Icons.local_dining, label: 'Dairy'),
      _CategoryItem(icon: Icons.more_horiz, label: 'More'),
    ];

    return SizedBox(
      height: _getResponsiveSize(100, context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              // Handle category tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected category: ${category.label}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveSize(8.0, context),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(_getResponsiveSize(12.0, context)),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category.icon,
                      size: _getResponsiveSize(24.0, context),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: _getResponsiveSize(4.0, context)),
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: _getResponsiveSize(12.0, context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedProducts(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth * 0.4; // 40% of screen width
    final itemHeight = itemWidth * 1.6; // Maintain aspect ratio
    final products = Product.getSampleProducts();

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: EdgeInsets.only(
              left: _getResponsiveSize(8.0, context),
              right: _getResponsiveSize(4.0, context),
              bottom: _getResponsiveSize(16.0, context),
              top: _getResponsiveSize(4.0, context),
            ),
            child: Card(
              child: Container(
                width: itemWidth,
                padding: EdgeInsets.all(_getResponsiveSize(10.0, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Image
                    Container(
                      height: itemWidth * 0.6, // 60% of item width
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: itemWidth * 0.1, // 10% of item width
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Product Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Farmer Name
                    Text(
                      'by ${product.farmerName}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Price and Add to Cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}/${product.unit}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          onPressed: () {
                            // TODO: Add to cart functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added ${product.name} to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyFarmers(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final farmers = Farmer.getSampleFarmers();

    return SizedBox(
      height: screenWidth * 0.32, // 32% of screen width
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: farmers.length,
        itemBuilder: (context, index) {
          final farmer = farmers[index];
          return Padding(
            padding: EdgeInsets.only(
              left: _getResponsiveSize(16.0, context),
              right: _getResponsiveSize(8.0, context),
              bottom: _getResponsiveSize(16.0, context),
            ),
            child: SizedBox(
              width:
                  MediaQuery.of(context).size.width *
                  0.6, // 60% of screen width
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Farmer Avatar
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 25),
                      ),
                      const SizedBox(width: 10),
                      // Farmer Info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              farmer.farmName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _getResponsiveSize(
                                  14.0,
                                  context,
                                ), // Responsive font size
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: _getResponsiveSize(
                                    12.0,
                                    context,
                                  ), // Responsive size
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${farmer.distance} miles away',
                                    style: TextStyle(
                                      fontSize: _getResponsiveSize(
                                        12.0,
                                        context,
                                      ),
                                    ), // Responsive font size
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(
                                5,
                                (starIndex) => Padding(
                                  padding: const EdgeInsets.only(right: 2.0),
                                  child: Icon(
                                    Icons.star,
                                    size: _getResponsiveSize(
                                      14.0,
                                      context,
                                    ), // Responsive size
                                    color: starIndex < farmer.rating.floor()
                                        ? Colors.amber
                                        : Colors.grey[300],
                                  ),
                                ),
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
