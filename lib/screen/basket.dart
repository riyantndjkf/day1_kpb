import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:day1_kpb/class/recipe.dart';

class Basket extends StatelessWidget {
  const Basket({super.key});

  List<Widget> widRecipes() {
    List<Widget> list = [];
    for (var recipe in recipes) {
      list.add(
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    recipe.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Image.network(
                  recipe.photo,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 200),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(recipe.desc),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Basket')),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: widRecipes(),
        ),
      ),
    );
  }
}
