import 'producto_model.dart';

class CarritoItem {
  final Producto producto;
  int cantidad;

  CarritoItem({required this.producto, this.cantidad = 1});

  double get subtotal => producto.precio * cantidad;

  Map<String, dynamic> toJson() {
    return {'productoId': producto.id, 'cantidad': cantidad};
  }
}
