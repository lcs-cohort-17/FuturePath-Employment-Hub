import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE03A2F)),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF9E9B96),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}