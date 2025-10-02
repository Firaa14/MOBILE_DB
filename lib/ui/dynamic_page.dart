import 'package:flutter/material.dart';

class DynamicPage extends StatelessWidget {
  final String title;
  const DynamicPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📄 $title")),
      body: Center(
        child: Text(
          "Ini adalah halaman: $title",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
