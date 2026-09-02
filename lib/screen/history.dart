//set up about page
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  //super.key ini untuk ngasih tau ke parent class kalo ini adalah key dari widget History,
  //jadi nanti bisa diakses dari parent classnya.
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text("This is History ")),
    );
  }
}
