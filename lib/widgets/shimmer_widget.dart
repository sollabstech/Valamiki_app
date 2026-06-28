import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/color_constants.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;
  final bool isCircle;

  const ShimmerWidget.rectangular({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 12,
  }) : isCircle = false;

  const ShimmerWidget.circular({
    super.key,
    required this.height,
    this.width,
  })  : borderRadius = 0,
        isCircle = true;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

// Pre-built shimmer layouts
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, color: Colors.white, margin: const EdgeInsets.only(bottom: 6)),
                  Container(height: 10, width: 80, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                  Container(height: 14, width: 60, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
