import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final _collection = FirebaseFirestore.instance.collection('users');

  Stream<List<UserModel>> getUsers() {
    return _collection.snapshots().map(
          (snapshot) =>
              snapshot.docs.map(UserModel.fromFirestore).toList(),
        );
  }

  Future<void> updateUser({
    required String uid,
    required String name,
    required String email,
    required String role,
  }) {
    return _collection.doc(uid).update({
      'name': name.trim(),
      'email': email.trim(),
      'role': role,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteUser(String uid) => _collection.doc(uid).delete();
}
