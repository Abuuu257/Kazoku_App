import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final items = app.cart.values.toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.separated(
              itemCount: items.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return ListTile(
                    title: const Text('Total'),
                    trailing: Text('LKR ${app.cartTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                }
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: Text(item.product.name),
                    subtitle: Text('LKR ${item.product.price.toStringAsFixed(2)} x ${item.qty}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Decrease',
                          onPressed: () {
                            final newQty = item.qty - 1;
                            if (newQty >= 1) {
                              app.updateQty(item.product.id, newQty);
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('${item.qty}'),
                        IconButton(
                          tooltip: 'Increase',
                          onPressed: () => app.updateQty(item.product.id, item.qty + 1),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        IconButton(
                          tooltip: 'Remove',
                          onPressed: () => app.removeFromCart(item.product.id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
