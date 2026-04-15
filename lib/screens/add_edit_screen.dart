import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';
import '../services/category_service.dart';

class AddEditScreen extends StatefulWidget {
  final TransactionModel? transaction;
  final VoidCallback toggleTheme;
  const AddEditScreen({super.key, this.transaction, required this.toggleTheme});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String type = "Expense";
  String category = "Food";
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> dynamicCategories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
    if (widget.transaction != null) {
      titleController.text = widget.transaction!.title;
      amountController.text = widget.transaction!.amount.toString();
      type = widget.transaction!.type;
      category = widget.transaction!.category;
      try {
        selectedDate = DateFormat('MMM dd, yyyy').parse(widget.transaction!.date);
      } catch (e) {
        selectedDate = DateTime.now();
      }
    }
  }

  void loadCategories() async {
    final data = await CategoryService.getCategories();
    setState(() {
      dynamicCategories = data;
      if (!dynamicCategories.any((element) => element['name'] == category)) {
        category = dynamicCategories.isNotEmpty ? dynamicCategories[0]['name'] : "Other";
      }
    });
  }

  void showAddCategoryDialog() {
    final nameController = TextEditingController();
    final iconController = TextEditingController();
    Color selectedColor = Colors.green;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text("New Category", style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.label_outline)),
                ),
                TextField(
                  controller: iconController,
                  decoration: const InputDecoration(labelText: "Emoji (e.g. 🍕)", prefixIcon: Icon(Icons.emoji_emotions_outlined)),
                ),
                const SizedBox(height: 20),
                const Align(alignment: Alignment.centerLeft, child: Text("Pick Color", style: TextStyle(fontWeight: FontWeight.w500))),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                    Colors.pink,
                    Colors.teal,
                  ].map((c) {
                    return GestureDetector(
                      onTap: () {
                        setStateDialog(() => selectedColor = c);
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: c,
                        child: selectedColor.value == c.value
                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty && iconController.text.isNotEmpty) {
                    await CategoryService.addCategory(
                      nameController.text,
                      iconController.text,
                      selectedColor,
                    );
                    Navigator.pop(context);
                    loadCategories();
                  }
                },
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Save"),
              )
            ],
          );
        });
      },
    );
  }

  save() async {
    if (!_formKey.currentState!.validate()) return;

    final data = TransactionModel(
      id: widget.transaction?.id,
      title: titleController.text,
      amount: double.parse(amountController.text),
      type: type,
      date: DateFormat('MMM dd, yyyy').format(selectedDate),
      category: category,
    );

    if (widget.transaction == null) {
      await DatabaseHelper.instance.insert(data);
    } else {
      await DatabaseHelper.instance.update(data);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.transaction == null ? "Add Transaction" : "Edit Transaction", 
          style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: colorScheme.onSurface),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Selector
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTypeTab("Income", Colors.green, isDark),
                      _buildTypeTab("Expense", Colors.red, isDark),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Amount Field
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "0.00",
                  prefixText: "₹ ",
                  prefixStyle: TextStyle(color: colorScheme.primary, fontSize: 32, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: colorScheme.outline.withOpacity(0.3)),
                ),
                validator: (v) => v!.isEmpty ? "Enter amount" : null,
              ),
              const Center(child: Text("Amount", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
              const SizedBox(height: 40),

              // Description
              _buildSectionTitle("Description", colorScheme),
              TextFormField(
                controller: titleController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: "What was this for?",
                  filled: true,
                  fillColor: isDark ? Colors.white.withOpacity(0.05) : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.edit_note_rounded),
                ),
                validator: (v) => v!.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 24),

              // Date Picker
              _buildSectionTitle("Date", colorScheme),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => selectedDate = date);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 20),
                      const SizedBox(width: 12),
                      Text(DateFormat('MMM dd, yyyy').format(selectedDate), 
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Category Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle("Category", colorScheme),
                  TextButton.icon(
                    onPressed: showAddCategoryDialog,
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: const Text("Add New"),
                  ),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: dynamicCategories.length,
                itemBuilder: (context, index) {
                  final cat = dynamicCategories[index];
                  final isSelected = category == cat['name'];
                  final catColor = Color(cat['color']);
                  return InkWell(
                    onTap: () => setState(() => category = cat['name']),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? catColor.withOpacity(0.15) 
                          : (isDark ? Colors.white.withOpacity(0.05) : colorScheme.surfaceContainerHighest.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? catColor : Colors.transparent, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat['icon'], style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text(cat['name'], 
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? catColor : (isDark ? Colors.white70 : colorScheme.outline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: const Text("Save Transaction", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface)),
    );
  }

  Widget _buildTypeTab(String label, Color color, bool isDark) {
    final isSelected = type == label;
    return GestureDetector(
      onTap: () => setState(() => type = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white38 : Colors.grey),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
