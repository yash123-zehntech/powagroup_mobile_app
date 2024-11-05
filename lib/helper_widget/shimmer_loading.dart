import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final child;

  bool? isLoading = false;

  ShimmerLoading({Key? key, @required this.child, @required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading!
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: true,
            child: child!)
        : child;
  }
}
