import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../providers/budget_providers.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  final CategoryModel? categoryToEdit;

  const AddCategoryScreen({super.key, this.categoryToEdit});

  @override
  ConsumerState<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _limitController = TextEditingController();

  // ... inside state class ...
  final List<IconData> _icons = [
    Icons.restaurant,
    Icons.shopping_cart,
    Icons.directions_car,
    Icons.home,
    Icons.health_and_safety,
    Icons.medical_services,
    Icons.school,
    Icons.fitness_center,
    Icons.card_giftcard,
    Icons.person,
  ];

  late int _selectedIconCode;

  // Predefined colors for the user to pick from
  final List<String> _colorPalette = [
    '0xFFF44336', // Red
    '0xFFE91E63', // Pink
    '0xFF9C27B0', // Purple
    '0xFF673AB7', // Deep Purple
    '0xFF3F51B5', // Indigo
    '0xFF2196F3', // Blue
    '0xFF03A9F4', // Light Blue
    '0xFF00BCD4', // Cyan
    '0xFF009688', // Teal
    '0xFF4CAF50', // Green
    '0xFF8BC34A', // Light Green
    '0xFFFFEB3B', // Yellow
    '0xFFFFC107', // Amber
    '0xFFFF9800', // Orange
    '0xFFFF5722', // Deep Orange
    '0xFF795548', // Brown
    '0xFF9E9E9E', // Grey
    '0xFF607D8B', // Blue Grey
  ];

  String _selectedColorHex = '0xFF2196F3'; // Default Blue

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if editing
    _nameController.text = widget.categoryToEdit?.name ?? '';
    _limitController.text =
        widget.categoryToEdit?.monthlyLimit.toString() ?? '';
    _selectedColorHex = widget.categoryToEdit?.colorHex ?? '0xFF2196F3';
    _selectedIconCode =
        widget.categoryToEdit?.iconCode ?? Icons.category.codePoint;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  void _submitCategory() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final limit = double.parse(_limitController.text);

      // 1. Create the model object
      final categoryData = CategoryModel(
        // Use existing ID if editing, otherwise let SQLite handle it (null)
        id: widget.categoryToEdit?.id,
        name: name,
        monthlyLimit: limit,
        colorHex: _selectedColorHex,
        iconCode: _selectedIconCode, // From the icon picker
      );

      // 2. Decide which Provider method to call
      if (widget.categoryToEdit != null) {
        // EDIT MODE
        ref.read(categoriesProvider.notifier).updateCategory(categoryData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category updated successfully')),
        );
      } else {
        // ADD MODE
        ref.read(categoriesProvider.notifier).addCategory(categoryData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category created successfully')),
        );
      }

      // 3. Close the screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: (widget.categoryToEdit != null)
            ? Text('Edit Category')
            : Text('New Category'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Name Input
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'e.g. Groceries',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 2. Limit Input
                TextFormField(
                  controller: _limitController,
                  decoration: InputDecoration(
                    labelText: 'Monthly Limit',
                    prefixText:  currency,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.monetization_on),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a limit';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildIconPicker(),
                const SizedBox(height: 24),

                // 3. Color Picker
                const Text(
                  'Pick a Color',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _colorPalette.map((colorHex) {
                    final color = Color(int.parse(colorHex));
                    final isSelected = _selectedColorHex == colorHex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorHex = colorHex;
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 3)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // 4. Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitCategory,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color(int.parse(_selectedColorHex)),
                    ),
                    child: (widget.categoryToEdit != null)
                        ? Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            'Create Category',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // UI for Icon Picker
  Widget _buildIconPicker() {
    return Wrap(
      spacing: 12,
      children: _icons.map((icon) {
        final isSelected = _selectedIconCode == icon.codePoint;
        return IconButton(
          icon: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          onPressed: () => setState(() => _selectedIconCode = icon.codePoint),
        );
      }).toList(),
    );
  }
}
