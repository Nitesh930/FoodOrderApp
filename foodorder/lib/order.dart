import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodorder/cart.dart';
import 'package:foodorder/store.dart';
import 'package:http/http.dart' as http;

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  late List<Color> _colorContainers;
  late List<Color> _colorTexts;
  late List<bool> _itemAdded = List<bool>.filled(4, false);

  @override
  void initState() {
    super.initState();
    _colorContainers = List<Color>.filled(4, Colors.white);
    _colorTexts = List<Color>.filled(4, Colors.grey);
  }

  void _onTap(int index) {
    setState(() {
      for (int i = 0; i < _colorContainers.length; i++) {
        if (i == index) {
          _colorContainers[i] = Color.fromARGB(255, 44, 170, 48);
          _colorTexts[i] = Colors.white;
        } else {
          _colorContainers[i] = Colors.white;
          _colorTexts[i] = Colors.grey;
        }
      }
    });
  }

  String _getTextForIndex(int index) {
    switch (index) {
      case 0:
        return "All";
      case 1:
        return "Veg";
      case 2:
        return "Non Veg";
      case 3:
        return "Starter";
      default:
        return "All";
    }
  }

  String _getTextIndex(int index) {
    switch (index) {
      case 0:
        return "Aalo tikki Burger";
      case 1:
        return "Paneer Burger";
      case 2:
        return "Chicken Burger";
      default:
        return "All";
    }
  }

  String _getText(int index) {
    switch (index) {
      case 0:
        return "Spicy Resturant";
      case 1:
        return "Cafe";
      case 2:
        return "Burger King";
      default:
        return "All";
    }
  }

  int _getPrice(int index) {
    switch (index) {
      case 0:
        return 93;
      case 1:
        return 10;
      case 2:
        return 40;
      default:
        return 0;
    }
  }

  var sum = 0;
  void _addItem(int index) async {
    var price = _getPrice(index);
    sum = sum + price;
    var ItemName = _getTextIndex(index);
    var regBody = {"ItemName": ItemName, "price": price};
    var resp = await http.post(
      Uri.parse(store),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );
    var jsonResp = jsonDecode(resp.body);
    print(price);
    print(sum);
    print(jsonResp);

    setState(() {
      _itemAdded[index] = true;
    });

    // Reset the icon after 1 second (adjust duration as needed)
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _itemAdded[index] = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(247, 255, 255, 255),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 200,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(25), // Set circular border radius
                    color: Color.fromARGB(255, 44, 170, 48),
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Get special discount',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          //  SizedBox(height: 3),
                          Padding(
                            padding: const EdgeInsets.only(right: 95.0),
                            child: Text(
                              'Up to 45%',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 100),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Claim Vouncher",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 44, 170, 48)),
                              ),
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(120, 50),
                                  backgroundColor: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Image.asset(
                        'assets/burger.jpg',
                        height: 120,
                        width: 120,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                      hintText: "Find your food...",
                      hintStyle: TextStyle(fontSize: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    4,
                    (index) => Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () => _onTap(index),
                          child: Container(
                            height: 90,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _colorContainers[index],
                            ),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Image.asset(
                                  'assets/food.jpeg',
                                  width: 60,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                _getTextForIndex(index),
                                style: TextStyle(
                                  color: _colorTexts[index],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]),
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 170),
                child: Text(
                  "Popular Food",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 200,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Image.asset(
                                'assets/burger.png',
                                height: 100,
                                width: 150,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              _getTextIndex(index),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              _getText(index),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "\$" + _getPrice(index).toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                ),
                                Container(
                                  width: 20.0,
                                  height: 30.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      _addItem(index);
                                    },
                                    child: _itemAdded[index]
                                        ? Icon(
                                            Icons.check,
                                            size: 18,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.add,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(255, 44, 170, 48)),
                                )
                              ],
                            )
                          ]),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                child: Text(
                  "next",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(400, 60),
                    backgroundColor: const Color.fromARGB(255, 44, 170, 48)),
              )
            ],
          ),
        ));
  }
}
