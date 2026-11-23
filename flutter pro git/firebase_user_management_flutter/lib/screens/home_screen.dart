import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_services.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomePageState();
}
class _HomePageState extends State<HomeScreen> {
  final name = TextEditingController();
  final city = TextEditingController();
  final salary = TextEditingController();
  final service = FirebaseServices();
  String? editingId;
  bool saving = false;
  @override
  void dispose() { name.dispose(); city.dispose(); salary.dispose(); super.dispose(); }
  Future<void> save() async {
    if (name.text.trim().isEmpty || city.text.trim().isEmpty || salary.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter all fields')));
      return;
    }
    setState(() => saving = true);
    try {
      if (editingId == null) {
        await service.addUser(name: name.text.trim(), city: city.text.trim(), salary: salary.text.trim());
      } else {
        await service.updateUser(editingId!, name: name.text.trim(), city: city.text.trim(), salary: salary.text.trim());
      }
      name.clear(); city.clear(); salary.clear(); editingId = null;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally { if (mounted) setState(() => saving = false); }
  }
  void edit(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    setState(() {
      editingId = doc.id;
      name.text = (data['name'] ?? '').toString();
      city.text = (data['city'] ?? '').toString();
      salary.text = (data['salary'] ?? '').toString();
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('User Management')),
    body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600),
      child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
        TextField(controller: city, decoration: const InputDecoration(labelText: 'City')),
        TextField(controller: salary, keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Salary')),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: saving ? null : save,
          child: Text(editingId == null ? 'Add User' : 'Update User')),
        Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: service.getUsers(), builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text('Firestore error: ${snapshot.error}'));
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return const Center(child: Text('No users added yet'));
            return ListView.builder(itemCount: docs.length, itemBuilder: (context, index) {
              final doc = docs[index]; final user = doc.data();
              return ListTile(
                title: Text((user['name'] ?? '').toString()),
                subtitle: Text('${user['city'] ?? ''} • ${user['salary'] ?? ''}'),
                trailing: Wrap(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () => edit(doc)),
                  IconButton(icon: const Icon(Icons.delete), onPressed: () async {
                    try { await service.deleteUser(doc.id); }
                    catch (e) { if (context.mounted) ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('$e'))); }
                  }),
                ]),
              );
            });
          },
        )),
      ]))),
    ),
  );
}
