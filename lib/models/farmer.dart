class Farmer {
  final String id;
  final String name;
  final String farmName;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double distance; // in miles
  final bool isCertified;
  final List<String> productCategories;
  final String location;

  Farmer({
    required this.id,
    required this.name,
    required this.farmName,
    required this.description,
    required this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.distance,
    this.isCertified = false,
    required this.productCategories,
    required this.location,
  });

  // Helper method to create a sample list of farmers for testing
  static List<Farmer> getSampleFarmers() {
    return [
      Farmer(
        id: 'f1',
        name: 'John Smith',
        farmName: 'Green Valley Farm',
        description: 'Family-owned organic farm since 1995, specializing in heirloom vegetables and herbs.',
        imageUrl: 'assets/images/farmer1.jpg',
        rating: 4.7,
        reviewCount: 42,
        distance: 2.3,
        isCertified: true,
        productCategories: ['Vegetables', 'Herbs', 'Fruits'],
        location: 'Springfield',
      ),
      Farmer(
        id: 'f2',
        name: 'Maria Garcia',
        farmName: 'Sunny Acres',
        description: 'Sustainable farming practices with a focus on seasonal produce and community support.',
        imageUrl: 'assets/images/farmer2.jpg',
        rating: 4.9,
        reviewCount: 36,
        distance: 3.1,
        isCertified: true,
        productCategories: ['Fruits', 'Vegetables', 'Honey'],
        location: 'Shelbyville',
      ),
      // Add more sample farmers as needed
    ];
  }
}
