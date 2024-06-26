import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leafloom/shared/core/constants.dart';
import 'package:leafloom/shared/core/utils/text_widget.dart';
import 'package:leafloom/view/address/widgets/address_card.dart';
import 'package:leafloom/view/address/widgets/dafault_card.dart';
import 'package:leafloom/view/checkout/widget/heading_delivery.dart';

class ScreenAddress extends StatefulWidget {
  const ScreenAddress({super.key});

  @override
  State<ScreenAddress> createState() => _ScreenAddressState();
}

String email = FirebaseAuth.instance.currentUser!.email!;

class _ScreenAddressState extends State<ScreenAddress> {
  final CollectionReference addressCollection = FirebaseFirestore.instance
      .collection('Address')
      .doc(email)
      .collection('UserAddress');

  @override
  void initState() {
    // email =
    super.initState();
  }

  // FirebaseFirestore.instance.collection('Address');
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomTextWidget(
            'My Addresses',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                kHeight20,
                const DeliveryHeading(),
                kHeight20,
                DefaultAddress(size: size),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: addressCollection.snapshots(),
                    builder: (context, snapshot) {
                      List<QueryDocumentSnapshot<Object?>> data = [];
                      if (snapshot.data == null) {
                        return const Center(
                          child: CustomTextWidget(
                            'Add Address',
                            fontSize: 16,
                          ),
                        );
                      }

                      data = snapshot.data!.docs;
                      if (snapshot.data!.docs.isEmpty || data.isEmpty) {
                        return const Center(
                          child: CustomTextWidget(
                            'Empty',
                            fontSize: 16,
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return AddressCard(
                            size: size,
                            area: data[index]['area'],
                            city: data[index]['city'],
                            fullname: data[index]['fullname'],
                            house: data[index]['house'],
                            id: data[index]['id'],
                            phone: data[index]['phone'],
                            pincode: data[index]["pincode"],
                            state: data[index]["state"],
                          );
                        },
                      );
                    },
                  ),
                ),
                kHeight50,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
