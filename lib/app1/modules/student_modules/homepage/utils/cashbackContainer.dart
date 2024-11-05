import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CashbackRedemptionCard extends StatefulWidget {
  final double cashbackAmount;
  final VoidCallback onRedeem;

  const CashbackRedemptionCard({
    Key? key,
    required this.cashbackAmount,
    required this.onRedeem,
  }) : super(key: key);

  @override
  _CashbackRedemptionCardState createState() => _CashbackRedemptionCardState();
}

class _CashbackRedemptionCardState extends State<CashbackRedemptionCard>
    with TickerProviderStateMixin {
  late AnimationController _sparkleController;
  late Animation<double> _sparkleAnimation;
  final Random _random = Random();

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play(); // Start animation when widget is shown

    _sparkleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();

    _sparkleAnimation =
        Tween<double>(begin: 0, end: 1).animate(_sparkleController);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _sparkleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti animation
        Container(
          child: Stack(
            children: [
              // Main Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6A11CB),
                      Color(0xFF2575FC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.celebration,
                          color: Colors.white,
                          size: 32,
                        ),
                        Text(
                          'Rs${widget.cashbackAmount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Congratulations! 🎉',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your cashback is ready to redeem',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: widget.onRedeem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Redeem Now',
                        style: TextStyle(
                          color: Color(0xFF6A11CB),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Animated Sparkles
              ...List.generate(10, (index) {
                return AnimatedBuilder(
                  animation: _sparkleAnimation,
                  builder: (context, child) {
                    final double random = _random.nextDouble();
                    final double offsetX =
                        cos((_sparkleAnimation.value + random) * 2 * pi) * 100;
                    final double offsetY =
                        sin((_sparkleAnimation.value + random) * 2 * pi) * 100;

                    return Positioned(
                      left: 150 + offsetX,
                      top: 100 + offsetY,
                      child: Opacity(
                        opacity: (1 - (_sparkleAnimation.value + random) % 1),
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20 * random,
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),

        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality:
              BlastDirectionality.explosive, // Random direction
          shouldLoop: false, // Animation plays once
          emissionFrequency: 0.05, // Controls speed of firework
          numberOfParticles: 70, // Number of particles
          maxBlastForce: 20, // Max force for explosion
          minBlastForce: 10, // Min force for explosion
          colors: const [
            Colors.red,
            Colors.blue,
            Colors.yellow,
            Colors.green,
            Colors.orange,
          ], // Colors of particles
          createParticlePath: _drawStar, // Custom star shape
        ),

        // Cashback container
      ],
    );
  }

  // Custom particle shape
  Path _drawStar(Size size) {
    // Draws a star shape
    double x = size.width / 2;
    double y = size.height / 2;
    return Path()
      ..moveTo(x, y - 15)
      ..lineTo(x + 10, y + 15)
      ..lineTo(x - 15, y - 5)
      ..lineTo(x + 15, y - 5)
      ..lineTo(x - 10, y + 15)
      ..close();
  }
}
