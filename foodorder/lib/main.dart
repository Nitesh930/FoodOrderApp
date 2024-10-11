import 'package:flutter/material.dart';
import 'package:foodorder/cart.dart';
import 'package:foodorder/home.dart';
import 'package:foodorder/order.dart';
import 'package:foodorder/store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: order(),
    );
  }
}
