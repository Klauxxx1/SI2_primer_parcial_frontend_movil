import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/producto_service.dart';
import '../services/recomendacion_inteligente_service.dart';

class RecomendacionesView extends StatefulWidget {
  const RecomendacionesView({Key? key}) : super(key: key);

  @override
  _RecomendacionesViewState createState() => _RecomendacionesViewState();
}

class _RecomendacionesViewState extends State<RecomendacionesView> {
  late Future<List<Producto>> _futureProductosRecomendados;
  final ProductoService _productoService = ProductoService();
  final RecomendacionInteligenteService _recomendacionService = RecomendacionInteligenteService();

  @override
  void initState() {
    super.initState();
    _futureProductosRecomendados = _recomendacionService.obtenerProductosRecomendados(
      _productoService,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos Recomendados'),
      ),
      body: FutureBuilder<List<Producto>>(
        future: _futureProductosRecomendados,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos recomendados'));
          } else {
            return _buildProductosList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildProductosList(List<Producto> productos) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        return _buildProductCard(productos[index]);
      },
    );
  }

  Widget _buildProductCard(Producto producto) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.network(
                producto.urlImagen,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 50.0),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '\$${producto.precio.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}