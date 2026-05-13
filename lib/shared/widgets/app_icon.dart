import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  final String path;
  final double size;
  final Color color;

  const AppIcon({super.key, required this.path, this.size = 24, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
