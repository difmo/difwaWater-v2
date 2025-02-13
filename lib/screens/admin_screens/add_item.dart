import 'dart:ui';

import 'package:difwa/controller/admin_controller/add_items_controller.dart';
import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AddItem> {
  final List<Map<String, dynamic>> bottleSizes = [
    {'size': 10, 'price': 10.0, 'image': 'assets/images/water.jpg'},
    {'size': 15, 'price': 20.0, 'image': 'assets/images/water.jpg'},
    {'size': 18, 'price': 25.0, 'image': 'assets/images/water.jpg'},
    {'size': 20, 'price': 30.0, 'image': 'assets/images/water.jpg'},
  ];

  int? selectedBottleSize;
  double vacantBottlePrice = 0.0;
  final FirebaseController _controller = FirebaseController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Waters'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Select a Bottle to Sell",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: bottleSizes.length,
                itemBuilder: (context, index) {
                  final bottle = bottleSizes[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBottleSize = bottle['size'];
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4,
                      color: selectedBottleSize == bottle['size']
                          ? Colors.blue.shade100
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              bottle['image'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${bottle['size']}L',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹ ${bottle['price']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (selectedBottleSize != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      'Selected Bottle: $selectedBottleSize L',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          vacantBottlePrice = double.tryParse(value) ?? 0.0;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Vacant Bottle Price (₹)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: '₹ 0.0',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (vacantBottlePrice > 0) {
                          try {
                            await _controller.addBottleData(
                              selectedBottleSize!,
                              bottleSizes.firstWhere((b) =>
                                  b['size'] == selectedBottleSize!)['price'],
                              vacantBottlePrice,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Bottle added successfully')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 32.0),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
