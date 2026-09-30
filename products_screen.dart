import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../services/category_service.dart';
import '../../services/product_service.dart';
import '../../widgets/product_card.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _search = TextEditingController();
  String _categoryFilter = 'all';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final categoryService = CategoryService();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF9A6848),
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddProductScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Product'),
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: categoryService.getCategories(),
        builder: (context, categorySnapshot) {
          final categories = categorySnapshot.data ?? [];
          final categoryMap = {
            for (final c in categories) c.id: c.name,
          };

          return StreamBuilder<List<ProductModel>>(
            stream: productService.getProducts(),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (productSnapshot.hasError) {
                return const Center(
                    child: Text('Unable to load products.'));
              }

              final query = _search.text.trim().toLowerCase();
              final products = (productSnapshot.data ?? []).where((product) {
                final matchesSearch =
                    product.name.toLowerCase().contains(query);
                final matchesCategory = _categoryFilter == 'all' ||
                    product.categoryId == _categoryFilter;
                return matchesSearch && matchesCategory;
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                    child: TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: Icon(Icons.coffee_rounded),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _filterChip('All', 'all'),
                        ...categories.map(
                          (category) => _filterChip(
                            category.name,
                            category.id,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: products.isEmpty
                        ? const Center(
                            child: Text(
                              'No products found.\nYour cozy shop is waiting for one.',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                                18, 8, 18, 100),
                            itemCount: products.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, index) {
                              final product = products[index];
                              return ProductCard(
                                product: product,
                                categoryName:
                                    categoryMap[product.categoryId] ??
                                        'Category unavailable',
                                onEdit: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProductScreen(
                                      product: product,
                                    ),
                                  ),
                                ),
                                onDelete: () => _delete(
                                  context,
                                  productService,
                                  product,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _categoryFilter == value,
        onSelected: (_) => setState(() => _categoryFilter = value),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    ProductService service,
    ProductModel product,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product?'),
        content: Text(product.name),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      await service.deleteProduct(product.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Product deleted.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }
}
