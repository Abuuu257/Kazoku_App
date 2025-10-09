import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../state/app_state.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 700 || MediaQuery.orientationOf(context) == Orientation.landscape;

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(product.image, fit: BoxFit.cover),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LKR ${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(product.description),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () {
            context.read<AppState>().addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to cart')),
            );
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Add to Cart'),
        ),
        const SizedBox(height: 8),
        Text('Details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('Category: ${product.category}\n'
            'Material: Pet-safe quality\n'
            'Shipping: Island-wide delivery available'),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: AspectRatio(aspectRatio: 1.4, child: image)),
                  const SizedBox(width: 16),
                  Expanded(flex: 4, child: SingleChildScrollView(child: details)),
                ],
              )
            : ListView(
                children: [
                  image,
                  const SizedBox(height: 12),
                  details,
                ],
              ),
      ),
    );
  }
}
