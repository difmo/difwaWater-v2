import 'package:flutter/material.dart';

class OrderDetailsComponent extends StatefulWidget {
  final int initialQuantity;
  final bool initialHasEmptyBottles;
  final Map<String, dynamic>? selectedPackage;
  final Function(int quantity, bool hasEmptyBottles, double totalPrice)
      onOrderUpdated;

  const OrderDetailsComponent({
    super.key,
    this.initialQuantity = 1,
    this.initialHasEmptyBottles = false,
    this.selectedPackage,
    required this.onOrderUpdated,
  });

  @override
  State<OrderDetailsComponent> createState() => _OrderDetailsComponentState();
}

class _OrderDetailsComponentState extends State<OrderDetailsComponent> {
  late int _quantity;
  late bool _hasEmptyBottle;
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _hasEmptyBottle = widget.initialHasEmptyBottles;
    _calculateTotal();
  }

  void _calculateTotal() {
    if (widget.selectedPackage != null) {
      double pricePerUnit = widget.selectedPackage!['price'];
      double vacantPrice =
          _hasEmptyBottle ? widget.selectedPackage!['vacantPrice'] : 0;

      _totalPrice = (_quantity * pricePerUnit) + (_quantity * vacantPrice);

      // Use WidgetsBinding to schedule the update after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onOrderUpdated(_quantity, _hasEmptyBottle, _totalPrice);
        }
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _calculateTotal();
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _calculateTotal();
      });
    }
  }

  void _toggleEmptyBottle(bool? value) {
    setState(() {
      _hasEmptyBottle = value ?? false;
      _calculateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details$_totalPrice',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                'Quantity',
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              // Decrease button
              IconButton(
                onPressed: _decrementQuantity,
                icon: const Icon(Icons.remove),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    const CircleBorder(),
                  ),
                ),
              ),

              // Quantity text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Increase button
              IconButton(
                onPressed: _incrementQuantity,
                icon: const Icon(Icons.add),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Checkbox for empty bottles
          Row(
            children: [
              Checkbox(
                value: _hasEmptyBottle,
                onChanged: _toggleEmptyBottle,
              ),
              const Text(
                'I have no empty bottles to return',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
