import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recomendacion_inteligente_model.dart';
import '../models/producto_model.dart';
import '../config.dart';
import '../services/producto_service.dart';

class RecomendacionInteligenteService {
  final String endpoint = '${Config.baseUrl}/recomendaciones_usuario';
  int _usuarioId = 1; // Variable temporal hasta implementar Provider

  // Setter para el usuarioId (se usará con Provider después)
  void setUsuarioId(int id) {
    _usuarioId = id;
  }

  Future<List<RecomendacionInteligente>> obtenerRecomendaciones() async {
    final response = await http.get(Uri.parse('$endpoint/$_usuarioId/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => RecomendacionInteligente.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las recomendaciones');
    }
  }

  Future<List<Producto>> obtenerProductosRecomendados(ProductoService productoService) async {
    try {
      final recomendaciones = await obtenerRecomendaciones();
      final productos = await productoService.obtenerProductos();
      
      // Mapear recomendaciones a productos
      return recomendaciones.map((recomendacion) {
        return productos.firstWhere(
          (producto) => producto.id == recomendacion.productoId,
          orElse: () => throw Exception('Producto no encontrado para la recomendación'),
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener productos recomendados: $e');
    }
  }
}