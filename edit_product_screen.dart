import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../services/category_service.dart';
import '../../services/product_service.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _quantity;
  late final TextEditingController _imageUrl;
  late String _categoryId;
  late bool _active;
  final _service = ProductService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p.name);
    _description = TextEditingController(text: p.description);
    _price = TextEditingController(text: p.price.toString());
    _quantity = TextEditingController(text: p.quantity.toString());
    _imageUrl = TextEditingController(text: p.imageUrl);
    _categoryId = p.categoryId;
    _active = p.isActive;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _quantity.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _service.updateProduct(
        id: widget.product.id,
        name: _name.text,
        description: _description.text,
        price: double.parse(_price.text.trim()),
        quantity: int.parse(_quantity.text.trim()),
        categoryId: _categoryId,
        imageUrl: _imageUrl.text,
        isActive: _active,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: StreamBuilder<List<CategoryModel>>(
        stream: CategoryService().getCategories(),
        builder: (context, snapshot) {
          final categories = snapshot.data ?? [];
          return _form(categories);
        },
      ),
    );
  }

  Widget _form(List<CategoryModel> categories) {
    final validCategory =
        categories.any((category) => category.id == _categoryId);
    if (!validCategory && categories.isNotEmpty) {
      // Keep the original ID if the category was deleted; update can still
      // preserve it and the Products screen will show "Category unavailable".
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Product Name'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Product name is required.'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _description,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Description is required.'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _price,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Price'),
              validator: (v) {
                final value = double.tryParse(v?.trim() ?? '');
                return value == null || value <= 0
                    ? 'Enter a valid positive price.'
                    : null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _quantity,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
              validator: (v) {
                final value = int.tryParse(v?.trim() ?? '');
                return value == null || value < 0
                    ? 'Enter a valid non-negative quantity.'
                    : null;
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: validCategory ? _categoryId : null,
              decoration: const InputDecoration(labelText: 'Category'),
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _categoryId = value);
              },
              validator: (_) => _categoryId.isEmpty
                  ? 'Category is required.'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _imageUrl,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            SwitchListTile(
              value: _active,
              onChanged: (v) => setState(() => _active = v),
              title: const Text('Active'),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _loading ? null : _update,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
