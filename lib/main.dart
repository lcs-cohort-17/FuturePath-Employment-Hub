import 'package:flutter/material.dart';
import 'screens/home/search_results_screen.dart';

void main() {
  runApp(const FuturePathApp());
}

class FuturePathApp extends StatelessWidget {
  const FuturePathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FuturePath Employment Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SearchResultsScreen(),
    );
  }
}