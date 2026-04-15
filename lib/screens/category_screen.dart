import 'package:flutter/material.dart';
import '../services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await CategoryService.getCategories();
    setState(() => categories = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final c = categories[i];

          return Dismissible(
            key: Key(c['name']),
            onDismissed: (_) async {
              await CategoryService.deleteCategory(c['name']);
              load();
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(c['color']),
                child: Text(c['icon']),
              ),
              title: Text(c['name']),
            ),
          );
        },
      ),
    );
  }
}
