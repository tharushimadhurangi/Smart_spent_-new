import 'package:flutter/material.dart';

class WalletIllustration extends StatelessWidget {
  final bool isIncome;

  const WalletIllustration({
    super.key,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final arrowColor = isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return SizedBox(
      height: 140,
      width: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft purple aura
          Positioned(
            top: 25,
            child: Container(
              width: 130,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                    blurRadius: 35,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),

          // Main Wallet Body
          Positioned(
            top: 32,
            left: 20,
            child: Container(
              width: 105,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9333EA),
                    Color(0xFF6B21A8),
                    Color(0xFF4C1D95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFC084FC).withValues(alpha: 0.5),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Wallet flap accent
                  Positioned(
                    right: 0,
                    top: 18,
                    child: Container(
                      width: 28,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7E22CE),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(12),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 6),
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDE047),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Upward or Downward Arrow Circle
          Positioned(
            top: 10,
            right: 28,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    arrowColor.withValues(alpha: 0.95),
                    arrowColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: arrowColor.withValues(alpha: 0.5),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                isIncome ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),

          // Golden Coins at the bottom right
          Positioned(
            bottom: 22,
            right: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCoin(18),
                Transform.translate(
                  offset: const Offset(-6, 2),
                  child: _buildCoin(22),
                ),
                Transform.translate(
                  offset: const Offset(-12, -2),
                  child: _buildCoin(17),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoin(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFEF08A),
            Color(0xFFEAB308),
            Color(0xFFCA8A04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFFEF9C3),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
