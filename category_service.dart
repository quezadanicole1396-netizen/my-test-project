import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final _collection = FirebaseFirestore.instance.collection('categories');

  Stream<List<CategoryModel>> getCategories() {
    return _collection.orderBy('name').snapshots().map(
          (snapshot) =>
              snapshot.docs.map(CategoryModel.fromFirestore).toList(),
        );
  }

  Future<void> createCategory({
    required String name,
    required String description,
    required String imageUrl,
    required bool isActive,
  }) {
    final now = Timestamp.now();
    return _collection.add({
      'name': name.trim(),
      'description': description.trim(),
      'imageUrl': imageUrl.trim(),
      'isActive': isActive,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required bool isActive,
  }) {
    return _collection.doc(id).update({
      'name': name.trim(),
      'description': description.trim(),
      'imageUrl': imageUrl.trim(),
      'isActive': isActive,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteCategory(String id) => _collection.doc(id).delete();
}
