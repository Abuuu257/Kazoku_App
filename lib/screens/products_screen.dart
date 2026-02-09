import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_card.dart';
import '../widgets/responsive_grid.dart';
import '../state/app_state.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<AppState>().products;

    if (products.isEmpty) {
      return const Center(child: Text('No products found or loading...'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ResponsiveGrid(
        children: [
          for (final p in products)
            ProductCard(
              product: p,
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ProductDetailScreen(product: p),
                    transitionsBuilder: (context, animation, sec, child) {
                      final tween = Tween(begin: const Offset(0, 0.1), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeOut));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                  ),
                );
              },
              onAdd: () => context.read<AppState>().addToCart(p),
            ),
        ],
      ),
    );
  }
}
