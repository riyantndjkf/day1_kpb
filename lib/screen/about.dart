import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: 
      SingleChildScrollView(child: Column(
        children: [
          Container(
            color: Colors.yellow,
            alignment: Alignment.center,
            width:200.0,
            height: 200.0,
            child: 
              Align(
                alignment: Alignment(0.2, -0.6), 
                child: Text('Ini Align'),
            )
          ),
          

          Container(
            color: const Color.fromARGB(255, 59, 255, 85),
            alignment: Alignment.center,
            width:200.0,
            height: 200.0,
            child: AspectRatio(
              aspectRatio: 1/3,
              child: Container(
                color:Colors.red  
              )
            )
          ),


          Container(
              color: Colors.cyan,
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.symmetric(horizontal: 45, vertical: 5),
              height: 300,
              width: 300,
              child: Card(child: Text('Hello World!')),
          ),


          Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/800?img=60'),
                    fit: BoxFit.fill,
                  ),
                  border: Border.all(
                    color: Colors.indigo,
                    width: 10,
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100),topRight: Radius.circular(100)),

                )),
              

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network('https://i.pravatar.cc/100?img=1'),
                  Image.network('https://i.pravatar.cc/100?img=2'),
                  Image.network('https://i.pravatar.cc/100?img=3'),
                ],
              ),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network('https://i.pravatar.cc/100?img=1'),
                  Image.network('https://i.pravatar.cc/100?img=2'),
                  Image.network('https://i.pravatar.cc/100?img=3'),
                ],
              ),


            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.network('https://i.pravatar.cc/100?img=1'),
                  Image.network('https://i.pravatar.cc/100?img=2'),
                  Image.network('https://i.pravatar.cc/100?img=3'),
                ],
              ),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network('https://i.pravatar.cc/60?img=1'),
                  Image.network('https://i.pravatar.cc/60?img=2'),
                  Image.network('https://i.pravatar.cc/60?img=3'),
                ],
              ),


            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network('https://i.pravatar.cc/60?img=1'),
                  Image.network('https://i.pravatar.cc/60?img=2'),
                  Image.network('https://i.pravatar.cc/60?img=3'),
                ],
              ),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network('https://i.pravatar.cc/60?img=1'),
                  Image.network('https://i.pravatar.cc/60?img=2'),
                  Image.network('https://i.pravatar.cc/60?img=3'),
                ],
              ),



            Divider(height: 10,),
              
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network('https://i.pravatar.cc/100?img=4'),
                  Image.network('https://i.pravatar.cc/100?img=5'),
                  Image.network('https://i.pravatar.cc/100?img=6'),
                  Image.network('https://i.pravatar.cc/100?img=7'),
                  Image.network('https://i.pravatar.cc/100?img=8'),
                  Image.network('https://i.pravatar.cc/100?img=9'),
                  Image.network('https://i.pravatar.cc/100?img=10'),
                ],
              ),

            ),


            Stack(
                children: [
                  Image.network("https://placecats.com/neo/400/400"),
                  Image.asset("assets/missing.png")
                ],
              ),


        ],
      ),
      
      
    ));
  }
}