import 'package:flutter/material.dart';
import 'package:day1_kpb/class/recipe.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _recipeDescController = TextEditingController();
  final TextEditingController _recipePhotoController = TextEditingController();

  int _charleft = 200;
  String _recipeCategory = "Indonesian";

  @override
  void initState() {
    super.initState();
    _recipeNameController.text = "";
    _recipeDescController.text = "";
    _recipePhotoController.text = "";
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _recipeDescController.dispose();
    _recipePhotoController.dispose();
    super.dispose();
  }

  Color getButtonColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return Colors.red;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _recipeNameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _recipeDescController,
              decoration: const InputDecoration(labelText: 'Recipe Description'),
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 5,
              maxLength: 200,
              onChanged: (v) {
                setState(() {
                  _charleft = 200 - v.length;
                });
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Characters left: $_charleft',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _recipePhotoController,
              decoration: const InputDecoration(labelText: 'Photo URL'),
              onSubmitted: (v) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            if (_recipePhotoController.text.isNotEmpty)
              Image.network(
                _recipePhotoController.text,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 200),
              ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _recipeCategory,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "Indonesian", child: Text("Indonesian")),
                DropdownMenuItem(value: "Japanese", child: Text("Japanese")),
                DropdownMenuItem(value: "Korean", child: Text("Korean")),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _recipeCategory = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(getButtonColor),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () {
                final newRecipe = Recipe(
                  id: recipes.length + 1,
                  name: _recipeNameController.text.isEmpty
                      ? "Unnamed Recipe"
                      : _recipeNameController.text,
                  desc: _recipeDescController.text,
                  photo: _recipePhotoController.text.isEmpty
                      ? "https://via.placeholder.com/200"
                      : _recipePhotoController.text,
                );
                
                setState(() {
                  recipes.add(newRecipe);
                });

                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Success'),
                      content: const Text('Recipe successfully added'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // Close dialog
                            // Optional: Navigator.of(context).pop(); // if we want to go back to prev screen
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
