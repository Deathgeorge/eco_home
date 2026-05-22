import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/product.dart';

class ProductListScreen extends StatefulWidget {
  final String token;

  const ProductListScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    // Reemplaza esta URL con la ruta real de tu servicio GET
    String host = 'localhost';
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      host = '10.0.2.2';
    }


    final url = Uri.parse('http://$host:8080/api/v1/products');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products. Status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          final products = snapshot.data!;
          
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Stock: ${product.stockQuantity ?? 0}\nCreado por: ${product.creatorName ?? "Desconocido"}'),
                  trailing: Text('\$${product.price?.toStringAsFixed(2) ?? "0.00"}', 
                    style: const TextStyle(color: Colors.green, fontSize: 16)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}