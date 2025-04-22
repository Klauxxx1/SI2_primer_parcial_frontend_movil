import 'package:flutter/material.dart';
import '../recomendaciones/recomendaciones_view.dart';

class PrincipalContent extends StatelessWidget {
  const PrincipalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/logo.jpg', height: 100),
          SizedBox(height: 10),
          Text(
            'SMART - CART',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Sistema de Punto de Venta (POS) con Inteligencia Artificial para el Reconocimiento de Voz y Recomendaciones de productos a comprar',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          RecomendacionesView(),
          //Image.asset('assets/carrito_teclado.jpg', height: 150),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
