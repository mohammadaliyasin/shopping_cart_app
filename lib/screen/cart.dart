import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havahavai_app/Provider/shopping_cart_provider.dart';
import 'package:havahavai_app/model/product_model.dart';

class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 167, 194),
      appBar: AppBar(
        title: Text('Cart',style: TextStyle(fontWeight: FontWeight.w500),),
        backgroundColor: const Color.fromARGB(255, 249, 167, 194),
        centerTitle: true,
      ),
      body:
          cartItems.isEmpty
              ? Center(child: Text('Your cart is empty'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartItems.keys.elementAt(index);
                        final quantity = cartItems[product]!;
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            child: ListTile(
                              leading: Image.network(
                                product.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.fill,
                              ),
                              title: Text(product.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '₹${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough,
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
                                  Text(
                                    '${product.discount.toStringAsFixed(0)}% off',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Quantity: $quantity',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      bottomSheet: Container(
        height: 100,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount Price',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  '₹${ref.watch(cartProvider.notifier).totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Check Out',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Text(
                      cartItems.length.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
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
