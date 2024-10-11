import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import 'store.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, int> itemMap = {};
  Map<String, int> itemPrice = {};
  final channel = IOWebSocketChannel.connect('ws://192.168.1.3:8080');

  @override
  void initState() {
    super.initState();
    itemMap = {};
    itemPrice = {};
    channel.stream.listen((message) {
      print('Received message: $message');
      List<dynamic> data = json.decode(message);
      setState(() {
        itemMap.clear();
        itemPrice.clear();
        for (var item in data) {
          String itemName = item['ItemName'];
          int price = item['price'];
          itemMap[itemName] = (itemMap[itemName] ?? 0) + 1;
          itemPrice[itemName] = price;
        }
      });
    });
  }

  void deleteItem(String itemName) async {
    final url = Uri.parse(delete); // Update with your actual URL
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'itemName': itemName}),
      );
      if (response.statusCode == 200) {
        print('Item deleted successfully: $itemName');
        setState(() {
          if (itemMap.containsKey(itemName)) {
            itemMap[itemName] = (itemMap[itemName]! - 1);
            if (itemMap[itemName]! <= 0) {
              itemMap.remove(itemName);
              itemPrice.remove(itemName);
            }
          }
        });
      } else {
        print('Failed to delete item: $itemName');
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = 0;

    itemMap.entries.forEach((entry) {
      String itemName = entry.key;
      int itemCount = entry.value;
      int totalItemPrice = (itemPrice[itemName] ?? 0) * itemCount;
      totalPrice += totalItemPrice;
    });

    return Scaffold(
      backgroundColor: Color.fromARGB(247, 255, 255, 255),
      appBar: AppBar(
        title: Text('Item Names'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: itemMap.entries.map((entry) {
            String itemName = entry.key;
            int itemCount = entry.value;
            int totalItemPrice = (itemPrice[itemName] ?? 0) * itemCount;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 250, // Set your desired height here
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Image.asset(
                          'assets/burger.png',
                          height: 100,
                          width: 150,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$itemName (x$itemCount)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Total Price: $totalItemPrice',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          // Call the function to delete the item
                          deleteItem(itemName);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 11.0),
                            child: Icon(
                              Icons.minimize,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 44, 170, 48)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Center(
            child: Text(
              'Total: $totalPrice',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
