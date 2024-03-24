import 'package:flutter/material.dart';
import 'package:leafloom/provider/cart/cart_provider.dart';
import 'package:leafloom/view/cart/widget/cart_product_card.dart';
import 'package:leafloom/view/checkout_page/screens/checkout_page.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CartProvider>().getCart(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<CartProvider>(builder: (context, value, _) {
                if (value.cartList.isEmpty) {
                  return const Center(
                    child: Text("Cart is empty"),
                  );
                }
                return ListView.builder(
                    itemCount: value.cartList.length,
                    itemBuilder: (context, index) {
                      final cartProduct = value.cartList[index];
                      return CartProductCard(
                        cartModel: cartProduct,
                      );
                    });
              }),
            ),
            Consumer<CartProvider>(builder: (context, value, _) {
              final total = value.getPrice(value.cartList);
              return Visibility(
                visible: value.cartList.isNotEmpty,
                child: Container(
                  color: Colors.white,
                  height: 70,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          subtitle: Text(
                            'Total (${value.cartList.length} items):',
                          ),
                          title: Text(
                            '₹ $total',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CheckoutScreen(products: value.cartList),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.all(10),
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Place Order',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
