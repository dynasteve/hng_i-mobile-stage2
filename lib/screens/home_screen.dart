import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'add_edit_product_screen.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  void _openAddProduct(BuildContext context, {Product? product}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditProductScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.products
        .where((p) =>
            p.name.toLowerCase().contains(_searchQuery.toLowerCase().trim()))
        .toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          elevation: 0,
          title: Image.asset(
            'assets/supermarket_logo.png',
            height: 120,
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search products...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),

            // 🧾 Product list
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   'assets/supermarket_logo.png',
                          //   height: 100,
                          // ),
                          // const SizedBox(height: 20),
                          const Text(
                            'No products found!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try adjusting your search or add new items.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black45),
                          ),
                        ],
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
                                          color: Colors.white),
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
                                  provider.deleteProduct(product.id!);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
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
