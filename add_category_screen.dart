import 'package:flutter/material.dart';
import '../../services/category_service.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _imageUrl = TextEditingController();
  final _service = CategoryService();
  bool _active = true;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _service.createCategory(
        name: _name.text,
        description: _description.text,
        imageUrl: _imageUrl.text,
        isActive: _active,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Create failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Create Category')),
        body: _form(
          buttonText: 'Create Category',
          onSubmit: _create,
        ),
      );

  Widget _form({required String buttonText, required VoidCallback onSubmit}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Category Name'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Category name is required.'
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
              onPressed: _loading ? null : onSubmit,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
