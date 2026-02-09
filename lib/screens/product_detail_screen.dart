import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import '../widgets/product_image.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 700 || MediaQuery.orientationOf(context) == Orientation.landscape;

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: ProductImage(image: product.image, fit: BoxFit.contain),
      ),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LKR ${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(product.name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              context.read<AppState>().addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to cart')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.category_outlined),
          title: Text('Category: ${product.category}'),
        ),
        const ListTile(
          leading: Icon(Icons.verified_user_outlined),
          title: Text('Material: Pet-safe quality'),
        ),
        const ListTile(
          leading: Icon(Icons.local_shipping_outlined),
          title: Text('Shipping: Island-wide delivery available'),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: image),
                  const SizedBox(width: 24),
                  Expanded(flex: 4, child: details),
                ],
              )
            : Column(
                children: [
                  image,
                  const SizedBox(height: 24),
                  details,
                ],
              ),
      ),
    );
  }
}
