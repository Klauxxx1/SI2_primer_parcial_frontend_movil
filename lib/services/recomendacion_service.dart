import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto_model.dart';
import '../config.dart';

class RecomendacionService {
  final String baseUrl = Config.baseUrl;

  Future<List<Producto>> obtenerRecomendacionesPorUsuario(
    dynamic userId,
  ) async {
    // Convertir el ID al tipo correcto si es necesario
    final id = userId.toString(); // Convertir a String si la API lo requiere

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recomendaciones/usuario/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) => Producto.fromJson(item)).toList();
      } else {
        // Si hay un error, devolver lista vacía
        return [];
      }
    } catch (e) {
      print('Error obteniendo recomendaciones: $e');
      return [];
    }
  }

  Future<List<Producto>> obtenerProductosMasVendidos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos/mas-vendidos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) => Producto.fromJson(item)).toList();
      } else {
        // Si el endpoint específico no existe, intentamos otra alternativa
        return await _obtenerProductosMasVendidosAlternativo();
      }
    } catch (e) {
      print('Error obteniendo productos más vendidos: $e');
      return await _obtenerProductosMasVendidosAlternativo();
    }
  }

  Future<List<Producto>> _obtenerProductosMasVendidosAlternativo() async {
    try {
      // Intenta obtener todas las ventas
      final ventasResponse = await http.get(
        Uri.parse('$baseUrl/ventas'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (ventasResponse.statusCode == 200) {
        List<dynamic> ventas = json.decode(ventasResponse.body);

        // Crea un mapa para contar la frecuencia de cada producto
        Map<int, int> frecuenciaProductos = {};

        // Recorre las ventas y cuenta la frecuencia de cada producto
        for (var venta in ventas) {
          for (var detalle in venta['detalles'] ?? []) {
            int productoId = detalle['productoId'];
            frecuenciaProductos[productoId] =
                (frecuenciaProductos[productoId] ?? 0) + 1;
          }
        }

        // Ordena los productos por frecuencia
        List<MapEntry<int, int>> productosOrdenados =
            frecuenciaProductos.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

        // Obtener los IDs de los productos más vendidos (máximo 10)
        List<int> idsProductosMasVendidos =
            productosOrdenados.take(10).map((e) => e.key).toList();

        if (idsProductosMasVendidos.isEmpty) {
          // Si no hay ventas, simplemente devuelve los productos destacados o recientes
          return await _obtenerProductosDestacados();
        }

        // Obtener los detalles de estos productos
        List<Producto> productosMasVendidos = [];

        for (int id in idsProductosMasVendidos) {
          try {
            final productoResponse = await http.get(
              Uri.parse('$baseUrl/productos/$id'),
            );

            if (productoResponse.statusCode == 200) {
              productosMasVendidos.add(
                Producto.fromJson(json.decode(productoResponse.body)),
              );
            }
          } catch (e) {
            print('Error obteniendo detalle del producto $id: $e');
          }
        }

        return productosMasVendidos;
      } else {
        return await _obtenerProductosDestacados();
      }
    } catch (e) {
      print('Error en método alternativo: $e');
      return await _obtenerProductosDestacados();
    }
  }

  Future<List<Producto>> _obtenerProductosDestacados() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos?destacado=true'),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) => Producto.fromJson(item)).toList();
      } else {
        // Si todo falla, simplemente devuelve los primeros productos disponibles
        final todosResponse = await http.get(Uri.parse('$baseUrl/productos'));
        if (todosResponse.statusCode == 200) {
          List<dynamic> body = json.decode(todosResponse.body);
          return body.take(10).map((item) => Producto.fromJson(item)).toList();
        }
      }

      return [];
    } catch (e) {
      print('Error obteniendo productos destacados: $e');
      return [];
    }
  }
}
