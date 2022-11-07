import 'package:cryptocurrency_app/app_theme.dart';
import 'package:cryptocurrency_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.getThemeValues();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Currency App',
      theme: ThemeData(
        primaryColor: Colors.deepOrange[100],
      ),
      home: const HomeScreen(),
    );
  }
}
