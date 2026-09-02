//set up about page
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  //super.key ini untuk ngasih tau ke parent class kalo ini adalah key dari widget Search,
  //jadi nanti bisa diakses dari parent classnya.
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text("This is Search ")),
    );
  }
}
