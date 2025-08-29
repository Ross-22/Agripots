import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/urban_farm.dart';
import '../services/location_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};
  LatLng? _currentPosition;
  bool _isLoading = true;
  String _searchQuery = '';

  // Sample data - in a real app, this would come from an API
  final List<UrbanFarm> _farms = [
    UrbanFarm(
      id: '1',
      name: 'Green Thumb Urban Farm',
      description: 'Organic vegetables and herbs',
      latitude: 14.5995, // Sample coordinates (Manila)
      longitude: 120.9842,
      address: '123 Green St, Metro Manila',
      rating: 4.5,
      tags: ['organic', 'vegetables', 'herbs'],
    ),
    UrbanFarm(
      id: '2',
      name: 'City Harvest',
      description: 'Urban farming community',
      latitude: 14.5794,
      longitude: 121.0359,
      address: '456 Urban Ave, Makati',
      rating: 4.2,
      tags: ['community', 'education', 'workshops'],
    ),
    // Add more sample farms as needed
  ];

  @override
  void initState() {
    super.initState();
    // Set a default position (Manila) in case location services fail
    _currentPosition = const LatLng(14.5995, 120.9842);
    _updateMarkers();
    _initializeMap();
    _getCurrentLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No need for platform-specific initialization here
    // Google Maps will be initialized when the map is created
  }

  // Initialize the map
  Future<void> _initializeMap() async {
    try {
      // Skip location check if on web
      final bool isWeb = identical(0, 0.0); // Check if running on web
      bool hasLocationPermission = true;

      if (!isWeb) {
        hasLocationPermission = await _checkLocationServices();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (!hasLocationPermission) {
        // Show a message if location services are not available
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location services are required for this feature'),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error initializing map: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to initialize map'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // Check if location services are available
  Future<bool> _checkLocationServices() async {
    try {
      final bool isWeb = identical(0, 0.0);

      // On web, we'll assume location services are available
      if (isWeb) {
        return true;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever
        return false;
      }

      // Permissions are granted
      return true;
    } catch (e) {
      debugPrint('Error checking location services: $e');
      return false;
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    if (_currentPosition != null) {
      // Already have a position, no need to get it again
      return;
    }

    try {
      // Skip permission check if on web
      final bool isWeb = identical(0, 0.0);
      bool hasPermission = true;

      if (!isWeb) {
        hasPermission = await _checkLocationServices();
      }

      if (!hasPermission) {
        // If we don't have permission, use default location that was set in initState
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      // Try to get the current position
      Position position = await LocationService.getCurrentLocation();
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
        _updateMarkers();
        _moveToCurrentLocation();
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
      // If we can't get the current location, the default will be used
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not determine your current location'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _moveToCurrentLocation() async {
    if (_currentPosition != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14.0),
        ),
      );
    }
  }

  void _updateMarkers() {
    if (_currentPosition == null) return;

    // Clear existing markers
    setState(() {
      _markers.clear();

      // Add current location marker
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      // Add farm markers
      for (var farm in _farms) {
        if (_searchQuery.isEmpty ||
            farm.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            farm.tags.any(
              (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
            )) {
          _markers.add(
            Marker(
              markerId: MarkerId(farm.id),
              position: LatLng(farm.latitude, farm.longitude),
              infoWindow: InfoWindow(
                title: farm.name,
                snippet: farm.description,
                onTap: () {
                  // TODO: Show farm details
                },
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ),
          );
        }
      }
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
  }

  Future<void> _onSearch() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchQuery = '';
        _updateMarkers();
      });
      return;
    }

    try {
      final location = await LocationService.getLatLngFromAddress(
        _searchController.text,
      );
      if (location != null) {
        setState(() {
          _currentPosition = location;
          _searchQuery = _searchController.text;
        });
        _updateMarkers();
        _moveToCurrentLocation();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Location not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching location: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? const LatLng(14.5995, 120.9842),
              zoom: 14.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onTap: (LatLng position) {
              // Close keyboard when tapping on map
              FocusScope.of(context).unfocus();
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for urban farms...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                              _updateMarkers();
                            });
                          },
                        )
                      : null,
                ),
                onSubmitted: (_) => _onSearch(),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _moveToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
