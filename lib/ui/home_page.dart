import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Go to About (with Message)"),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/about',
                  arguments: "Halo, ini pesan dari Home ke About!",
                );
              },
            ),
            ElevatedButton(
              child: Text("Go to Contact"),
              onPressed: () {
                Navigator.pushNamed(context, '/contact');
              },
            ),
            ElevatedButton(
              child: Text("Go to Input Page (Dynamic Page)"),
              onPressed: () {
                Navigator.pushNamed(context, '/input');
              },
            ),
          ],
        ),
      ),
    );
  }
}
