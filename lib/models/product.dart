class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String imageUrl;
  final String farmerId;
  final String farmerName;
  final double rating;
  final int reviewCount;
  final bool isOrganic;
  final DateTime harvestDate;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.farmerId,
    required this.farmerName,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isOrganic = false,
    required this.harvestDate,
  });

  // Helper method to create a sample list of products for testing
  static List<Product> getSampleProducts() {
    return [
      Product(
        id: '1',
        name: 'Organic Tomatoes',
        description: 'Freshly picked organic tomatoes from our greenhouse',
        price: 3.99,
        unit: 'lb',
        imageUrl: 'assets/images/tomatoes.jpg',
        farmerId: 'f1',
        farmerName: 'Green Valley Farm',
        rating: 4.5,
        reviewCount: 24,
        isOrganic: true,
        harvestDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Product(
        id: '2',
        name: 'Fresh Basil',
        description: 'Aromatic basil leaves, perfect for Italian dishes',
        price: 2.50,
        unit: 'bunch',
        imageUrl: 'assets/images/basil.jpg',
        farmerId: 'f1',
        farmerName: 'Green Valley Farm',
        rating: 4.8,
        reviewCount: 15,
        isOrganic: true,
        harvestDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      // Add more sample products as needed
    ];
  }
}
