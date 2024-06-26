import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leafloom/model/address/address_model.dart';
import 'package:leafloom/model/cart/cart_model.dart';
import 'package:leafloom/model/order/order_model.dart';
import 'package:leafloom/provider/address/address_provider.dart';
import 'package:leafloom/provider/bottomnavbar/bottom_nav_bar_provider.dart';
import 'package:leafloom/provider/cart/cart_provider.dart';
import 'package:leafloom/provider/checkout/checkout_provider.dart';
import 'package:leafloom/shared/bottomnavigation/bottom_bar.dart';
import 'package:leafloom/shared/common_widget/common_button.dart';
import 'package:leafloom/shared/core/constants.dart';
import 'package:leafloom/shared/core/utils/text_widget.dart';
import 'package:leafloom/view/address/screens/main_address_screen.dart';
import 'package:leafloom/view/address/widgets/dafault_card.dart';
import 'package:leafloom/view/checkout/widget/heading_delivery.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

Razorpay razorpay = Razorpay();

// ignore: must_be_immutable
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<CartModel> products;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

AddressModel? selectedAddress;

class _CheckoutScreenState extends State<CheckoutScreen> {
  int calculateTotalAmount(List<CartModel> products) {
    int totalAmount = 0;
    for (var product in products) {
      int price = int.tryParse(product.price ?? '0') ?? 0;
      int quantity = int.tryParse(product.quantity ?? '0') ?? 0;
      totalAmount += price * quantity;
    }
    return totalAmount;
  }

  DateTime currentDate = DateTime.now();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String date = '0';

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    date = formattedDate;
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final razorpayProvider = Provider.of<RazorpayProvider>(context);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomTextWidget(
            'Check out',
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              kHeight20,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: size.height / 8,
                  child: const DeliveryHeading(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 9,
                  right: 9,
                ),
                child: DefaultAddress(size: size),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ScreenAddress(),
                    ),
                  );
                  context
                      .read<AddressProvider>()
                      .showSnackbar(context, 'Change address default');
                },
                child: const CustomTextWidget(
                  'Select Address',
                  fontSize: 16,
                ),
              ),
              kHeight20,
              for (var product in widget.products) ...[
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10.0),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            product.imageUrl ??
                                'https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.salonlfc.com%2Fwp-content%2Fuploads%2F2018%2F01%2Fimage-not-found-scaled.png&tbnid=EQhG80gDXt9AJM&vet=12ahUKEwixkcr9xdKCAxWBoekKHQTjCBAQMygBegQIARBH..i&imgrefurl=https%3A%2F%2Fwww.salonlfc.com%2Fen%2Fimage-not-found%2F&docid=rb42RVdX5acoCM&w=2560&h=1440&q=image%20not%20found&ved=2ahUKEwixkcr9xdKCAxWBoekKHQTjCBAQMygBegQIARBH',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                product.name ?? '',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: CustomTextWidget(
                                  '₹ ${product.price ?? ''}',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const CustomTextWidget(
                                    'Qty: ',
                                    fontSize: 12,
                                  ),
                                  CustomTextWidget(
                                    product.quantity ?? '',
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomTextWidget(
                    'Total : ',
                  ),
                  CustomTextWidget(
                    ' ₹${calculateTotalAmount(widget.products)}',
                  ),
                ],
              ),
              ListTile(
                leading: Radio<PaymentCategory>(
                  groupValue: checkoutProvider.paymentCategory,
                  value: PaymentCategory.paynow,
                  onChanged: (PaymentCategory? value) {
                    checkoutProvider.setPaymentCategory(value!);
                  },
                ),
                title: const CustomTextWidget(
                  'Pay Now',
                  fontSize: 16,
                ),
              ),
              //=================================cash on delivery=======================================
              // ListTile(
              //   leading: Radio<PaymentCategory>(
              //     groupValue: checkoutProvider.paymentCategory,
              //     value: PaymentCategory.cashondelivery,
              //     onChanged: (PaymentCategory? value) {
              //       checkoutProvider.setPaymentCategory(value!);
              //     },
              //   ),
              //   title: const CustomTextWidget('Cash on delivery',fontsize: 16,),
              // ),
              // kHeight50,
            ],
          ),
        ),
        bottomNavigationBar: CommonButton(
          name: "Confirm order",
          voidCallback: () async {
            if (checkoutProvider.paymentCategory == PaymentCategory.paynow) {
              final user = FirebaseAuth.instance.currentUser;
              for (var product in widget.products) {
                int total = calculateTotalAmount(widget.products);
                var options = {
                  'key': 'rzp_test_pUzi5U4xQ2GSYV',
                  'amount': total * 100,
                  'name': 'LeafLoom',
                  'description': product.name ?? '',
                  'retry': {'enabled': true, 'max_count': 1},
                  'send_sms_hash': true,
                  'prefill': {'contact': '9605298500', 'email': user!.email},
                  'external': {
                    'bank_account': {
                      'account_number': '99980113744705',
                      'ifsc': 'FDRL0001089',
                      'name': 'Akshay P'
                    }
                  }
                };
                final defaultAddress = await FirebaseFirestore.instance
                    .collection('Address')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .collection('default_address')
                    .doc('1')
                    .get();
                final address = AddressModel.fromJson(defaultAddress.data()!);
                final obj = OrderModel(
                  orderId: uniqueFileName,
                  status: 'Pending',
                  // ignore: use_build_context_synchronously
                  quantity:
                      // ignore: use_build_context_synchronously
                      context.read<CheckoutProvider>().totalNum.toString(),
                  id: product.id,
                  description: product.description,
                  category: product.category,
                  imageUrl: product.imageUrl,
                  productName: product.name,
                  totalPrice: product.price,
                  date: date,
                  address: address,
                  email: FirebaseAuth.instance.currentUser!.email,
                );
                // ignore: use_build_context_synchronously
                context
                    .read<ProductPayment>()
                    // ignore: use_build_context_synchronously
                    .confirm(value: obj, context: context);
                razorpayProvider.openRazorpayPayment(
                  options: options,
                  onError: (response) {
                    handlePaymentErrorResponse(response, context);
                  },
                  onSuccess: (response) {
                    handlePaymentSuccessResponse(response, context);
                  },
                );
              }
            } else {
              for (var product in widget.products) {
                final obj = OrderModel(
                  orderId: uniqueFileName,
                  status: 'Pending',
                  quantity:
                      context.read<CheckoutProvider>().totalNum.toString(),
                  id: product.id,
                  description: product.description,
                  category: product.category,
                  imageUrl: product.imageUrl,
                  productName: product.name,
                  totalPrice: product.price,
                  date: date,
                  email: FirebaseAuth.instance.currentUser!.email,
                );
                context
                    .read<ProductPayment>()
                    .confirm(value: obj, context: context);
                context
                    .read<CheckoutProvider>()
                    .showPaymentCompletedDialog(context);
              }
            }
          },
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(
      PaymentFailureResponse response, BuildContext context) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
     */
    showAlertDialogForPayNow(
        context, "Payment Failed", "\nDescription: ${response.message}}");
  }

  void handlePaymentSuccessResponse(
      PaymentSuccessResponse response, BuildContext context) {
    // ignore: unused_local_variable
    String id = response.orderId.toString();

    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialogForPayNow(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(
      ExternalWalletResponse response, BuildContext context) {
    showAlertDialogForPayNow(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialogForPayNow(
      BuildContext context, String title, String message) {
    Widget continueButton = Consumer<NavBarBottom>(
      builder: (context, value, child) {
        return ElevatedButton(
          child: const CustomTextWidget(
            "Continue",
            fontSize: 16,
          ),
          onPressed: () {
            context.read<CartProvider>().clearCart(context);
            Provider.of<NavBarBottom>(context, listen: false).selectedIndex = 0;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenNavWidget(),
              ),
              ((route) => false),
            );
          },
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: CustomTextWidget(
        title,
        fontSize: 16,
      ),
      content: CustomTextWidget(
        message,
        fontSize: 16,
      ),
      actions: [
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertDialogForCashOnDelivery(
      BuildContext context, String title, String message) {
    Widget continueButton = Consumer<NavBarBottom>(
      builder: (context, value, child) {
        return ElevatedButton(
          child: const CustomTextWidget(
            "Continue",
            fontSize: 16,
          ),
          onPressed: () {
            context.read<CartProvider>().clearCart(context);
            Provider.of<NavBarBottom>(context, listen: false).selectedIndex = 0;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenNavWidget(),
              ),
              ((route) => false),
            );
          },
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: CustomTextWidget(
        title,
        fontSize: 16,
      ),
      content: CustomTextWidget(
        message,
        fontSize: 16,
      ),
      actions: [
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
