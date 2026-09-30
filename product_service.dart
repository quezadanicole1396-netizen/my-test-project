import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final _collection = FirebaseFirestore.instance.collection('products');

  Stream<List<ProductModel>> getProducts() {
    return _collection.orderBy('name').snapshots().map(
          (snapshot) =>
              snapshot.docs.map(ProductModel.fromFirestore).toList(),
        );
  }

  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String categoryId,
    required String imageUrl,
    required bool isActive,
  }) {
    final now = Timestamp.now();
    return _collection.add({
      'name': name.trim(),
      'description': description.trim(),
      'price': price,
      'quantity': quantity,
      'categoryId': categoryId,
      'imageUrl': imageUrl.trim(),
      'isActive': isActive,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String categoryId,
    required String imageUrl,
    required bool isActive,
  }) {
    return _collection.doc(id).update({
      'name': name.trim(),
      'description': description.trim(),
      'price': price,
      'quantity': quantity,
      'categoryId': categoryId,
      'imageUrl': imageUrl.trim(),
      'isActive': isActive,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteProduct(String id) => _collection.doc(id).delete();
}
