import 'package:flutter/material.dart';

class ItemBasket extends StatelessWidget {
  final int id;
  final int count;
  const ItemBasket(this.id, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Basket')),
      body: Center(child: Text("Item $id count= $count")
      ),
      
    );
    
  }
}
