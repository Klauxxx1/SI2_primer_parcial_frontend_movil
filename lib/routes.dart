import 'package:flutter/material.dart';
import 'package:frontend_movil/views/auth/login_view.dart';
import 'package:frontend_movil/views/auth/register_view.dart';
import 'package:frontend_movil/views/carrito/compra_view.dart';
import 'package:frontend_movil/views/carrito/detalle_carrito_view.dart';
import 'package:frontend_movil/views/carrito/lista_carritos_view.dart';
import 'package:frontend_movil/views/catalogo/catalogo_productos_view.dart';
import 'package:frontend_movil/views/home/main_page.dart';
import 'package:frontend_movil/views/persona/persona_view.dart';
import 'package:frontend_movil/views/recomendaciones_view.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => MainPage(),

  '/personas': (context) => const PersonaView(),

  '/mas_vendidos':
      (context) => Scaffold(
        appBar: AppBar(title: Text('Productos más vendidos')),
        body: Center(child: Text('Aquí van los productos más vendidos')),
      ),

  '/descuentos':
      (context) => Scaffold(
        appBar: AppBar(title: Text('Descuentos')),
        body: Center(child: Text('Aquí van los descuentos disponibles')),
      ),

  '/catalogo': (context) => const CatalogoProductosView(),
  '/carritos': (context) => const ListaCarritosView(),
  '/carrito_detalle': (context) => const DetalleCarritoView(),

  '/login': (context) => const LoginView(),
  '/register': (context) => const RegisterView(),
  '/compra': (context) => const CompraView(),
    '/recomendaciones': (context) => const RecomendacionesView(),
};
