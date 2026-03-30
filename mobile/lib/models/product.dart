class Product {
  final int id;
  final String name;
  final String? categoryName;
  final String description;
  final double price;
  final String? image;
  final String availableSizes;
  final int stock;
  final bool featured;
  final bool isInStock;

  Product({
    required this.id,
    required this.name,
    this.categoryName,
    required this.description,
    required this.price,
    this.image,
    required this.availableSizes,
    required this.stock,
    required this.featured,
    required this.isInStock,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'],
        name: j['name'],
        categoryName: j['category']?['name'],
        description: j['description'],
        price: double.parse(j['price'].toString()),
        image: j['image'],
        availableSizes: j['available_sizes'] ?? '',
        stock: j['stock'] ?? 0,
        featured: j['featured'] ?? false,
        isInStock: j['is_in_stock'] ?? false,
      );
}
