import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'ui/about_page.dart';
import 'ui/contact_page.dart';
import 'ui/input_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/about': (context) => AboutPage(),
        '/contact': (context) => ContactPage(),
        '/input': (context) => InputPage(),
      },
    );
  }
}
