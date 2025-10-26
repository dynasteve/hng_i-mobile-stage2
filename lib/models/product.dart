class Product {
  int? id;
  String name;
  String? description; // ✅ added this
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
      'description': description, // ✅ added
      'quantity': quantity,
      'price': price,
      'imagePath': imagePath,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  // Create Product from Map (retrieved from database)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'], // ✅ added
      quantity: map['quantity'],
      price: map['price'],
      imagePath: map['imagePath'],
    );
  }
}
