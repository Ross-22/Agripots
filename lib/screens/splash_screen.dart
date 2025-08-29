import 'dart:math';
import 'package:flutter/material.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _leafController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _growAnimation;
  late Animation<double> _rotateAnimation;
  
  final List<LeafParticle> leaves = [];
  final Random _random = Random();
  
  static const int _numLeaves = 12;
  static const Duration _animationDuration = Duration(seconds: 4);
  static const Duration _transitionDuration = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    
    // Initialize leaf particles first
    _initLeaves();
    
    // Main animation controller
    _mainController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _startTransition();
        }
      });
    
    // Leaf animation controller - for smooth leaf movement
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _leafController.repeat();
        }
      });

    // Main animations
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOutQuart),
      ),
    );

    _growAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Start the animations
    _mainController.forward();
    _leafController.forward();  // Start leaf animation
    
    // Update leaves position periodically instead of on every build
    _startLeafAnimation();
  }
  
  void _initLeaves() {
    for (int i = 0; i < _numLeaves; i++) {
      leaves.add(LeafParticle(
        left: _random.nextDouble() * 300,
        top: _random.nextDouble() * 600,
        size: 8.0 + _random.nextDouble() * 16.0,
        speed: 1.0 + _random.nextDouble() * 3.0,
        angle: _random.nextDouble() * 2 * pi,
        rotationSpeed: _random.nextDouble() * 2 - 1,
      ));
    }
  }
  
  void _updateLeaves() {
    if (mounted) {
      setState(() {
        for (var leaf in leaves) {
          leaf.update();
        }
      });
    }
  }
  
  void _startLeafAnimation() {
    // Update leaves every frame for smooth animation
    _leafController.addListener(() {
      if (mounted) {
        bool needsUpdate = false;
        for (var leaf in leaves) {
          final prevTop = leaf.top;
          leaf.update();
          if ((leaf.top - prevTop).abs() > 0.1) {
            needsUpdate = true;
          }
        }
        if (needsUpdate && mounted) {
          setState(() {});
        }
      }
    });
  }
  
  void _startTransition() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, 
                Animation<double> secondaryAnimation) {
              return const MainNavigation();
            },
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutQuart,
                  ),
                ),
                child: child,
              );
            },
            transitionDuration: _transitionDuration,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _leafController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update leaves in each build
    _updateLeaves();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFFE8F5E9),
                ],
              ),
            ),
          ),
          
          // Animated leaves in the background
          ...leaves.map((leaf) {
            return Positioned(
              left: leaf.left,
              top: leaf.top,
              child: AnimatedBuilder(
                animation: _leafController,
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: leaf.angle + (_leafController.value * leaf.rotationSpeed * 2 * pi),
                    child: Opacity(
                      opacity: 0.7,
                      child: Icon(
                        Icons.eco,
                        size: leaf.size,
                        color: Colors.green.withOpacity(0.6 + 0.4 * _mainController.value),
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          
          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (BuildContext context, Widget? child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main animated garden scene
                    AnimatedBuilder(
                      animation: _mainController,
                      builder: (context, _) => Transform.scale(
                        scale: _scaleAnimation.value,
                        child: RotationTransition(
                          turns: _rotateAnimation,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animated garden bed
                              Container(
                                width: 220,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.brown.shade200,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.brown.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Soil
                                    Positioned.fill(
                                      top: 50,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF5D4037),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    // Plants
                                    Positioned(
                                      bottom: 30,
                                      left: 30,
                                      child: _buildAnimatedPlant(
                                        color: const Color(0xFF4CAF50),
                                        delay: 0.0,
                                        size: 40,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 30,
                                      left: 90,
                                      child: _buildAnimatedPlant(
                                        color: const Color(0xFF8BC34A),
                                        delay: 0.2,
                                        size: 60,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 30,
                                      right: 30,
                                      child: _buildAnimatedPlant(
                                        color: const Color(0xFF4CAF50),
                                        delay: 0.4,
                                        size: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Watering can
                              Positioned(
                                right: 30.0,
                                top: -30.0,
                                child: Transform.rotate(
                                  angle: -0.2,
                                  child: AnimatedBuilder(
                                    animation: _mainController,
                                    builder: (BuildContext context, Widget? child) {
                                      return Transform.translate(
                                        offset: Offset(0, 20 * (1 - _mainController.value)),
                                        child: Icon(
                                          Icons.water_drop,
                                          size: 30,
                                          color: Colors.blue.shade300,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // App name with creative animation
                    AnimatedBuilder(
                      animation: _mainController,
                      builder: (BuildContext context, Widget? child) {
                        final word1 = 'Agri';
                        final word2 = 'Pots';
                        
                        return ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              const Color(0xFF4CAF50),
                              const Color(0xFF8BC34A).withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // First part with letter-by-letter animation
                              ...List.generate(word1.length, (index) {
                                final letter = word1[index];
                                final letterValue = _mainController.value * word1.length - index;
                                final opacity = letterValue.clamp(0.0, 1.0);
                                final offset = (1 - opacity) * 20;
                                
                                return Transform.translate(
                                  offset: Offset(0, offset),
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Text(
                                      letter,
                                      style: const TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Colors.black26,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              
                              // Second part with different animation
                              ...List.generate(word2.length, (index) {
                                final letter = word2[index];
                                final letterValue = _mainController.value * word2.length - index;
                                final scale = letterValue.clamp(0.0, 1.0);
                                final opacity = scale;
                                
                                return Transform.scale(
                                  scale: scale,
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Text(
                                      letter,
                                      style: const TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Colors.black26,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Animated tagline
                    AnimatedBuilder(
                      animation: _mainController,
                      builder: (BuildContext context, Widget? child) {
                        final tagline = 'Cultivating Freshness in Every Pot';
                        final startFade = 0.4;
                        final endFade = 0.9;
                        final fadeRange = endFade - startFade;
                        final fadeProgress = ((_mainController.value - startFade) / fadeRange).clamp(0.0, 1.0);
                        
                        return Opacity(
                          opacity: fadeProgress,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - fadeProgress)),
                            child: Text(
                              tagline,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Animated progress indicator
                    AnimatedBuilder(
                      animation: _mainController,
                      builder: (BuildContext context, Widget? child) {
                        return Container(
                          width: 200,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 200 * _mainController.value,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4CAF50),
                                    Color(0xFF8BC34A),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnimatedPlant({
    required Color color,
    required double delay,
    required double size,
  }) {
    final animation = CurvedAnimation(
      parent: _mainController,
      curve: Interval(
        delay,
        0.8,
        curve: Curves.elasticOut,
      ),
    );
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: Icon(
              Icons.eco,
              size: size * animation.value,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

class LeafParticle {
  double left;
  double top;
  final double size;
  final double speed;
  double angle;
  final double rotationSpeed;
  final Random _random = Random();
  double _drift = 0;
  double _driftSpeed = 0;
  
  LeafParticle({
    required this.left,
    required this.top,
    required this.size,
    required this.speed,
    required this.angle,
    required this.rotationSpeed,
  }) {
    _drift = _random.nextDouble() * 2 - 1; // Random drift between -1 and 1
    _driftSpeed = 0.2 + _random.nextDouble() * 0.6; // Random drift speed
  }
  
  void update() {
    // Move leaf in a gentle falling motion with slight horizontal drift
    top += speed * 0.5;
    angle += 0.01 * rotationSpeed;
    
    // Add subtle horizontal drift
    _drift += (_random.nextDouble() * 2 - 1) * 0.05;
    _drift = _drift.clamp(-1.0, 1.0);
    left += _drift * _driftSpeed;
    
    // Keep leaves within bounds
    if (left < -20) left = -20;
    if (left > 400) left = 400;
    
    // Reset if off screen
    if (top > 800) {
      top = -50;
      left = _random.nextDouble() * 400;
      // Reset drift when leaf is recycled
      _drift = _random.nextDouble() * 2 - 1;
    }
  }
}
