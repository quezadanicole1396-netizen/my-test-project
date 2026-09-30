import 'package:flutter/material.dart';

class CozyImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const CozyImage({
    super.key,
    required this.url,
    this.height = 130,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) return _placeholder();

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFF2E3D5),
        borderRadius: borderRadius,
      ),
      child: const Icon(
        Icons.local_cafe_rounded,
        size: 42,
        color: Color(0xFF9A6848),
      ),
    );
  }
}
