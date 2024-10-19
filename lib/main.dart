import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled8/Home%20page.dart';
import 'package:untitled8/cart_provider.dart';
import 'package:untitled8/product_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            title: "Shopping App",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.cyan),
            home: Homepage(),
          );
        },
      ),
    );
  }
}
