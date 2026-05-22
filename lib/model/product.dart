class Product {
  final int idProduct;
  final String name;
  final String? status;
  final double? price;
  final int? stockQuantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? creatorName;

  Product({
    required this.idProduct,
    required this.name,
    this.status,
    this.price,
    this.stockQuantity,
    this.createdAt,
    this.updatedAt,
    this.creatorName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Leemos las llaves usando camelCase (nuevo JSON) o snake_case (por seguridad)
    final idProd = json['idProduct'] ?? json['id_product'];
    final stock = json['stockQuantity'] ?? json['stock_quantity'];
    final created = json['createdAt'] ?? json['created_at'];
    final updated = json['updatedAt'] ?? json['updated_at'];

    return Product(
      idProduct: idProd is int ? idProd : int.tryParse(idProd?.toString() ?? '') ?? 0,
      name: json['name'] ?? '',
      status: json['status'],
      // Se asegura de convertir numeric(10,2) a double, independientemente si viene como int, double o string
      price: json['price'] != null 
          ? double.tryParse(json['price'].toString()) 
          : null,
      stockQuantity: stock is int ? stock : int.tryParse(stock?.toString() ?? ''),
      createdAt: created != null ? DateTime.tryParse(created) : null,
      updatedAt: updated != null ? DateTime.tryParse(updated) : null,
      creatorName: json['createdBy'] != null ? json['createdBy']['name'] : null,
    );
  }
}
