import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: ColoredBox(
        color: Colors.black26,
        child: Center(
          child: SizedBox(
            width: 70,
            height: 70,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}
