class Product {
  final int idProduct;
  final String name;
  final String? status;
  final double? price;
  final int? stockQuantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.idProduct,
    required this.name,
    this.status,
    this.price,
    this.stockQuantity,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduct: json['id_product'] is int 
          ? json['id_product'] 
          : int.tryParse(json['id_product'].toString()) ?? 0,
      name: json['name'] ?? '',
      status: json['status'],
      // Se asegura de convertir numeric(10,2) a double, independientemente si viene como int, double o string
      price: json['price'] != null 
          ? double.tryParse(json['price'].toString()) 
          : null,
      stockQuantity: json['stock_quantity'] is int 
          ? json['stock_quantity'] 
          : int.tryParse(json['stock_quantity']?.toString() ?? ''),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }
}