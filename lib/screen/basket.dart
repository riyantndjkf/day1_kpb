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
