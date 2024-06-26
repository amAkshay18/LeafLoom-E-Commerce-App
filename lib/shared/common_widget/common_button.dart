import 'package:flutter/material.dart';
import 'package:leafloom/shared/core/utils/text_widget.dart';

// ignore: must_be_immutable
class CommonButton extends StatelessWidget {
  CommonButton({super.key, required this.name, required this.voidCallback});
  final String name;
  VoidCallback voidCallback;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            voidCallback();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: CustomTextWidget(
            name,
            fontSize: 18,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
