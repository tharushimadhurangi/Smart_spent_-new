import 'package:flutter/material.dart';

class WalletIllustration extends StatelessWidget {
  final bool isIncome;

  const WalletIllustration({
    super.key,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    if (!isIncome) {
      return _buildExpenseIllustration();
    }

    return SizedBox(
      height: 145,
      width: 220,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background soft ambient purple aura glow
          Positioned(
            top: 25,
            child: Container(
              width: 140,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.45),
                    blurRadius: 40,
                    spreadRadius: 12,
                  ),
                ],
              ),
            ),
          ),

          // Sparkle Stars (4-point sparkle stars)
          Positioned(
            top: 20,
            left: 28,
            child: _buildSparkle(8, const Color(0xFFDDD6FE)),
          ),
          Positioned(
            top: 48,
            left: 12,
            child: _buildSparkle(12, const Color(0xFFC084FC)),
          ),
          Positioned(
            top: 10,
            right: 48,
            child: _buildSparkle(10, const Color(0xFFE9D5FF)),
          ),
          Positioned(
            top: 36,
            right: 18,
            child: _buildSparkle(7, const Color(0xFFC084FC)),
          ),

          // Bar Chart Columns (behind wallet on the right)
          Positioned(
            top: 28,
            right: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(9, 36, const Color(0xFF7C3AED)),
                const SizedBox(width: 4),
                _buildBar(9, 52, const Color(0xFF8B5CF6)),
              ],
            ),
          ),

          // 3D Upward Arrow (pointing top-right behind wallet)
          Positioned(
            top: 12,
            right: 56,
            child: CustomPaint(
              size: const Size(38, 48),
              painter: _UpwardArrowPainter(),
            ),
          ),

          // Main 3D Blue Wallet Body
          Positioned(
            top: 16,
            left: 36,
            child: Container(
              width: 114,
              height: 82,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF60A5FA),
                    Color(0xFF3B82F6),
                    Color(0xFF2563EB),
                    Color(0xFF1D4ED8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF93C5FD).withValues(alpha: 0.7),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.55),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Inner top card pocket layer
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    height: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF60A5FA).withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                    ),
                  ),

                  // Front Wallet Flap & Snap
                  Positioned(
                    right: 0,
                    top: 24,
                    child: Container(
                      width: 32,
                      height: 40,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF3B82F6),
                            Color(0xFF1D4ED8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(-2, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 6),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE0F2FE),
                          border: Border.all(
                            color: const Color(0xFF93C5FD),
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Left Coin (₹)
          Positioned(
            bottom: 22,
            left: 16,
            child: _buildCoin(
              size: 28,
              symbol: '₹',
            ),
          ),

          // Right Rear Coin (₹)
          Positioned(
            bottom: 22,
            right: 36,
            child: _buildCoin(
              size: 32,
              symbol: '₹',
            ),
          ),

          // Right Front Coin (₹)
          Positioned(
            bottom: 12,
            right: 52,
            child: _buildCoin(
              size: 26,
              symbol: '₹',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkle(double size, Color color) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SparklePainter(color: color),
    );
  }

  Widget _buildBar(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildCoin({required double size, required String symbol}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: [
            Color(0xFFFEF08A),
            Color(0xFFFBBF24),
            Color(0xFFF59E0B),
            Color(0xFFD97706),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFEF9C3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB45309).withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        symbol,
        style: TextStyle(
          color: const Color(0xFF92400E),
          fontSize: size * 0.48,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildExpenseIllustration() {
    return SizedBox(
      height: 150,
      width: 220,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background circular purple/pink halo glow
          Positioned(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6B21A8).withValues(alpha: 0.5),
                    const Color(0xFF3B0764).withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC026D3).withValues(alpha: 0.35),
                    blurRadius: 35,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),

          // Main 3D Pink/Magenta Wallet Body
          Positioned(
            top: 24,
            left: 50,
            child: Container(
              width: 110,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF72A7),
                    Color(0xFFF43F5E),
                    Color(0xFFE11D48),
                    Color(0xFFBE123C),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFFFB3C6).withValues(alpha: 0.7),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF881337).withValues(alpha: 0.6),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Top inner card pocket layer
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    height: 18,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9F1239),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFFF72A7).withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                    ),
                  ),

                  // Front Wallet Flap & Snap
                  Positioned(
                    right: 0,
                    top: 24,
                    child: Container(
                      width: 32,
                      height: 38,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFF43F5E),
                            Color(0xFFBE123C),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 6),
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFE4E6),
                          border: Border.all(
                            color: const Color(0xFFFDA4AF),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Front Minus Badge (Pink circle with white minus bar)
          Positioned(
            bottom: 26,
            right: 48,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF4081),
                    Color(0xFFF43F5E),
                    Color(0xFFE11D48),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 2.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF43F5E).withValues(alpha: 0.7),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Container(
                width: 20,
                height: 4.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  final Color color;

  _SparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path();

    path.moveTo(cx, 0);
    path.quadraticBezierTo(cx, cy, size.width, cy);
    path.quadraticBezierTo(cx, cy, cx, size.height);
    path.quadraticBezierTo(cx, cy, 0, cy);
    path.quadraticBezierTo(cx, cy, cx, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UpwardArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFC084FC), Color(0xFF8B5CF6)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width * 0.35, size.height * 0.1);
    path.lineTo(size.width * 0.55, size.height * 0.32);
    path.lineTo(0, size.height * 0.88);
    path.lineTo(size.width * 0.28, size.height);
    path.lineTo(size.width * 0.82, size.height * 0.44);
    path.lineTo(size.width * 0.98, size.height * 0.62);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
