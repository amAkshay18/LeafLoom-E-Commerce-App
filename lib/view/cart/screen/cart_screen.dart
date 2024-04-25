import 'package:flutter/material.dart';
import 'package:leafloom/provider/cart/cart_provider.dart';
import 'package:leafloom/shared/core/utils/text_widget.dart';
import 'package:leafloom/view/cart/widget/cart_product_card.dart';
import 'package:leafloom/view/checkout/screens/checkout_screen.dart';
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
          title: const CustomTextWidget(
            'Cart',
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<CartProvider>(builder: (context, value, _) {
                if (value.cartList.isEmpty) {
                  return const Center(
                    child: CustomTextWidget(
                      "Cart is empty",
                      fontSize: 16,
                    ),
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
                          subtitle: CustomTextWidget(
                            'Total (${value.cartList.length} items):',
                            fontSize: 16,
                          ),
                          title: CustomTextWidget(
                            '₹$total',
                            fontWeight: FontWeight.bold,
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
                            child: const CustomTextWidget(
                              'Place Order',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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

// import 'package:flutter/material.dart';
// import 'package:leafloom/provider/cart/cart_provider.dart';
// import 'package:leafloom/shared/core/utils/text_widget.dart';
// import 'package:leafloom/view/cart/widget/cart_product_card.dart';
// import 'package:leafloom/view/checkout/screens/checkout_screen.dart';
// import 'package:provider/provider.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() => context.read<CartProvider>().getCart(context));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const CustomTextWidget('Cart'),
//           centerTitle: true,
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: Consumer<CartProvider>(
//                 builder: (context, value, _) {
//                   if (value.cartList.isEmpty) {
//                     return const Center(
//                       child: CustomTextWidget(
//                         "Cart is empty",
//                         fontSize: 16,
//                       ),
//                     );
//                   }
//                   return ListView.builder(
//                     itemCount: value.cartList.length,
//                     itemBuilder: (context, index) {
//                       final cartProduct = value.cartList[index];
//                       return CartProductCard(
//                         cartModel: cartProduct,
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             Consumer<CartProvider>(
//               builder: (context, value, _) {
//                 final total = value.getPrice(value.cartList);
//                 return Visibility(
//                   visible: value.cartList.isNotEmpty,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Total (${value.cartList.length} items):',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               '₹ $total',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.amber,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => CheckoutScreen(
//                                     products: value.cartList,
//                                   ),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               // primary: Colors.amber,
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text(
//                               'Place Order',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
