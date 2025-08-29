class UrbanFarm {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final double rating;
  final String imageUrl;
  final List<String> tags;

  UrbanFarm({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.rating = 0.0,
    this.imageUrl = 'assets/images/default_farm.jpg',
    this.tags = const [],
  });

  // Factory method to create an UrbanFarm from JSON
  factory UrbanFarm.fromJson(Map<String, dynamic> json) {
    return UrbanFarm(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Farm',
      description: json['description'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'] ?? 'No address provided',
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? 'assets/images/default_farm.jpg',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  // Convert UrbanFarm to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'rating': rating,
      'imageUrl': imageUrl,
      'tags': tags,
    };
  }
}
