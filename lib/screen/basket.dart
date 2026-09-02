import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../class/recipe.dart';




class Basket extends StatelessWidget {
  
Basket({super.key});
  

List<Widget> widRecipes() {
    List<Widget> temp = [];
    int i = 0;
    while (i < recipes.length) {
      Widget w = Container(
        margin:const EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(128, 128, 128, 0.5),
              spreadRadius: -6,
              blurRadius: 8,
              offset: const Offset(8, 7),
            ),
          ]
        ),
child:
        Card(
          child: Column(
            children: [
              Container (
                margin: const EdgeInsets.all(15),
                child: Text( 
                  recipes[i].name,
                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                )
              ),
              Image.network(recipes[i].photo),
              Container (
                margin: const EdgeInsets.all(20),
                child: Text(recipes[i].desc),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(recipes[i].category),
                    if (recipes[i].type == 'Vegetarian')
                      const Text("Vegetarian", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: recipes[i].level == 'Easy' ? Colors.green : (recipes[i].level == 'Medium' ? Colors.yellow : Colors.red),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Text(recipes[i].level, style: TextStyle(color: recipes[i].level == 'Medium' ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              )
            ]
          ) 
        )
      );
      temp.add(w);
      i++;
    }
    return temp;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basket')),
      body: SingleChildScrollView(
	child: Column(children: [
          Text("Your basket "),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: widRecipes(),
          ),
          Divider(
            height: 100,
          )
  	])
),

    );
  }
}
