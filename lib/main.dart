import 'package:flutter/material.dart';
import 'package:frontend_movil/providers/carrito_provider.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/cart_provider.dart';
import 'widgets/global_overlay.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],

      child: const SmartCartApp(),
    ),
  );
}

class SmartCartApp extends StatelessWidget {
  const SmartCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Cart',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GlobalOverlay(),
    );
  }
}
