//set up about page
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  //super.key ini untuk ngasih tau ke parent class kalo ini adalah key dari widget Home,
  //jadi nanti bisa diakses dari parent classnya.
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is Home ")),
    );
  }
}
