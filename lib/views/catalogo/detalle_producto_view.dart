import 'package:flutter/material.dart';
import '../../models/producto_model.dart';
import '../../services/producto_service.dart';

class DetalleProductoView extends StatefulWidget {
  final Producto producto;

  const DetalleProductoView({super.key, required this.producto});

  @override
  _DetalleProductoViewState createState() => _DetalleProductoViewState();
}

class _DetalleProductoViewState extends State<DetalleProductoView> {
  List<Producto> _productosRelacionados = [];
  final ProductoService _productoService = ProductoService();

  @override
  void initState() {
    super.initState();
    _cargarProductosRelacionados();
  }

  Future<void> _cargarProductosRelacionados() async {
    try {
      final productos = await _productoService.obtenerProductosPorCategoria(
        widget.producto.categoriaId,
      );

      // Filtrar el producto actual y limitar a máximo 4 productos relacionados
      final relacionados =
          productos.where((p) => p.id != widget.producto.id).take(4).toList();

      setState(() {
        _productosRelacionados = relacionados;
      });
    } catch (e) {
      setState(() {});
      // Manejar error silenciosamente, ya que esto no es crítico
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Producto', style: TextStyle(fontSize: 18)),
        actions: [
          /*IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/carrito'),
          ),*/
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child:
                  widget.producto.urlImagen.isNotEmpty == true
                      ? Image.network(
                        widget.producto.urlImagen,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (_, __, ___) => const Icon(
                              Icons.image_not_supported,
                              size: 80,
                              color: Colors.grey,
                            ),
                      )
                      : const Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey,
                      ),
            ),

            // Información del producto
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.producto.nombre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bs ${widget.producto.precio.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descripción
                  const Text(
                    'Descripción:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.producto.descripcion ??
                        'No hay descripción disponible.',
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 1),

                  // Selección de cantidad
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Productos relacionados
            if (_productosRelacionados.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Productos relacionados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _productosRelacionados.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final producto = _productosRelacionados[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetalleProductoView(producto: producto),
                          ),
                        );
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagen del producto relacionado
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  producto.urlImagen.isNotEmpty == true
                                      ? Image.network(
                                        producto.urlImagen,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                            ),
                                      )
                                      : const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              producto.nombre,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Bs ${producto.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 40), // Espacio al final para mejor UX
          ],
        ),
      ),
    );
  }
}
