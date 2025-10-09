import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  final int compact;
  final int medium;
  final int expanded;
  final double spacing;
  final List<Widget> children;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.compact = 2,
    this.medium = 3,
    this.expanded = 4,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      int cols = compact;
      if (c.maxWidth >= 900) cols = expanded;
      else if (c.maxWidth >= 600) cols = medium;

      return GridView.count(
        crossAxisCount: cols,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 0.74,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: children,
      );
    });
  }
}
