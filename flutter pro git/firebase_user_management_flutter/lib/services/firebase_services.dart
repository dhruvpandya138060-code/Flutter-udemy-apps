import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseServices {
  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() => users.snapshots();
  Future<void> addUser({required String name, required String city,
    required String salary}) => users.add({'name': name, 'city': city, 'salary': salary}).then((_) {});
  Future<void> updateUser(String id, {required String name, required String city,
    required String salary}) => users.doc(id).update({'name': name, 'city': city, 'salary': salary});
  Future<void> deleteUser(String id) => users.doc(id).delete();
}
