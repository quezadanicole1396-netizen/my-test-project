import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../services/category_service.dart';
import '../../widgets/category_card.dart';
import 'add_category_screen.dart';
import 'edit_category_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = CategoryService();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF9A6848),
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddCategoryScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Category'),
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: service.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Unable to load categories.'));
          }

          final categories = snapshot.data ?? [];
          if (categories.isEmpty) {
            return const Center(
              child: Text('No categories yet.\nCreate your first category.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final category = categories[index];
              return CategoryCard(
                category: category,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EditCategoryScreen(category: category),
                  ),
                ),
                onDelete: () =>
                    _delete(context, service, category),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _delete(BuildContext context, CategoryService service,
      CategoryModel category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Are you sure you want to delete ${category.name}?'),
        content: const Text(
          'Products using this category will keep their category ID, '
          'but the category name may no longer be available.',
        ),
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
      await service.deleteCategory(category.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Category deleted.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }
}
