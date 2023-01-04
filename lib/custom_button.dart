import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.buttonText, required this.onTap})
      : super(key: key);
  final String buttonText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.blue),
          child: Center(
              child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          )),
        ),
      ),
    );
  }
}
