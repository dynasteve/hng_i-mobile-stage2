import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';
import 'add_edit_product_screen.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _sortOption = 'Name (A–Z)';

  void _openAddProduct(BuildContext context, {Product? product}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditProductScreen(product: product),
      ),
    );
  }

  List<Product> _getSortedProducts(List<Product> products) {
    List<Product> sorted = List.from(products);
    switch (_sortOption) {
      case 'Name (A–Z)':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name (Z–A)':
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Price (Low–High)':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price (High–Low)':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    List<Product> products = productProvider.products
        .where((p) => p.name
            .toLowerCase()
            .contains(_searchQuery.toLowerCase().trim()))
        .toList();

    products = _getSortedProducts(products);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Image.asset(
          'assets/supermarket_logo.png',
          height: 120,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(
                    'assets/supermarket_logo.png',
                    height: 100,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Close Panel'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search products...',
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _sortOption,
                    items: const [
                      DropdownMenuItem(
                        value: 'Name (A–Z)',
                        child: Text('A–Z'),
                      ),
                      DropdownMenuItem(
                        value: 'Name (Z–A)',
                        child: Text('Z–A'),
                      ),
                      DropdownMenuItem(
                        value: 'Price (Low–High)',
                        child: Text('Low–High'),
                      ),
                      DropdownMenuItem(
                        value: 'Price (High–Low)',
                        child: Text('High–Low'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sortOption = value);
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? const Center(
                      child: Text(
                        'No products found.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: product.imagePath != null &&
                                      File(product.imagePath!).existsSync()
                                  ? Image.file(
                                      File(product.imagePath!),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.blue.shade100,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Qty: ${product.quantity}  •  ₦${product.price}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _openAddProduct(context, product: product);
                                } else if (value == 'delete') {
                                  productProvider.deleteProduct(product.id!);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddProduct(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}
