import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havahavai_app/Provider/api_provider.dart';
import 'package:havahavai_app/model/product_model.dart';
import 'package:havahavai_app/screen/cart.dart';

final cartProvider = StateNotifierProvider<CartNotifier, Map<Product, int>>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<Map<Product, int>> {
  CartNotifier() : super({});

  void addToCart(Product product) {
    state = {...state, product: (state[product] ?? 0) + 1};
  }

  void removeFromCart(Product product) {
    if (state.containsKey(product)) {
      final currentQuantity = state[product]!;
      if (currentQuantity > 1) {
        state = {...state, product: currentQuantity - 1};
      } else {
        state = Map.from(state)..remove(product);
      }
    }
  }

  double get totalPrice => state.entries.fold(
    0,
    (sum, entry) => sum + (entry.key.discountedPrice * entry.value),
  );
}

class ProductListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);
    final cartItems = ref.watch(cartProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 167, 194),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 249, 167, 194),
        title: Text('Catalogue',style: TextStyle(fontWeight: FontWeight.w600),),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    ),
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartItems.length.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: products.when(
        data:
            (data) => GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final product = data[index];
                final quantity = cartItems[product] ?? 0;
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Text(
                              '₹${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '₹${product.discountedPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${product.discount.toStringAsFixed(0)}% off',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            quantity == 0
                                ? ElevatedButton(
                                  onPressed:
                                      () => ref
                                          .read(cartProvider.notifier)
                                          .addToCart(product),
                                  child: Text('Add'),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      onPressed:
                                          () => ref
                                              .read(cartProvider.notifier)
                                              .removeFromCart(product),
                                    ),
                                    Text(
                                      quantity.toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      onPressed:
                                          () => ref
                                              .read(cartProvider.notifier)
                                              .addToCart(product),
                                    ),
                                  ],
                                ),
                      ),
                    ],
                  ),
                );
              },
            ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading products')),
      ),
    );
  }
}
