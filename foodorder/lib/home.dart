import 'package:flutter/material.dart';
import 'package:foodorder/order.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(247, 255, 255, 255),
        body: Center(  
          child: SafeArea(
            child: Column(
              children: [
                Image.asset(
                  'assets/foodLogo.png',
                  height: 400,
                  width: 900,
                ),
                SizedBox(height: 3),
                Text(
                  "Fastest Food",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1),
                Text(
                  "Ordering Services",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Your order will be immediately collected",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 107, 107, 107)),
                ),
                SizedBox(height: 2),
                Text(
                  "and sent by our best delivery courler",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 107, 107, 107)),
                ),
                SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => order()));
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(400, 60),
                      backgroundColor: const Color.fromARGB(255, 44, 170, 48)),
                )
              ],
              
            ),
          ),
        ));
  }
}
