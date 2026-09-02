//set up about page
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  //super.key ini untuk ngasih tau ke parent class kalo ini adalah key dari widget About, 
  //jadi nanti bisa diakses dari parent classnya.
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text("This is About ")),
    );
  }
}
