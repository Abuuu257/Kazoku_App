import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/order.dart'; // Ensure Order is imported for type safety if needed
import '../widgets/product_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We shouldn't watch AppState here for methods, only for rebuilding
    // So splitting the build method logic might be cleaner, but for now:
    final app = context.watch<AppState>();
    final items = app.cart.values.toList();
    final isLoading = app.isLoading;

    if (items.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Total',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'LKR ${app.cartTotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  // Capture the navigator to use it safely after the async gap
                  final navigator = Navigator.of(context);
                  
                  // Use read instead of watch/app variable to be safe, though app var works too
                  await context.read<AppState>().checkout();
                  
                  // Show dialog using the captured navigator context
                  // We use push() on the navigator to show the dialog manually if showDialog is failing due to context
                  showDialog(
                    context: navigator.context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Purchase Confirmed'),
                      content: const Text('Thank you for your order! It has been placed successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text('Proceed to Checkout'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        }

        final item = items[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ProductImage(image: item.product.image),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'LKR ${item.product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                         final newQty = item.qty - 1;
                         if (newQty >= 1) {
                           app.updateQty(item.product.id, newQty);
                         } else {
                           app.removeFromCart(item.product.id);
                         }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${item.qty}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => app.updateQty(item.product.id, item.qty + 1),
                       padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => app.removeFromCart(item.product.id),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
