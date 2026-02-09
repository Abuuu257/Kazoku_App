import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ProductImage(image: product.image),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                product.category,
                style: TextStyle(color: cs.secondary, fontSize: 13),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LKR ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  IconButton(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_shopping_cart, size: 22),
                    tooltip: 'Add to cart',
                    style: IconButton.styleFrom(
                      foregroundColor: cs.primary,
                      backgroundColor: cs.primaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
