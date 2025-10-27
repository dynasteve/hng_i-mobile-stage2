class Product {
  int? id;
  String name;
  String? description;
  int quantity;
  double price;
  String? imagePath;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.quantity,
    required this.price,
    this.imagePath,
  });

  // Convert Product to Map for database storage
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'imagePath': imagePath,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  // Create Products from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      price: map['price'],
      imagePath: map['imagePath'],
    );
  }
}
