import 'package:flutter/material.dart';

class PackageSelectorComponent extends StatefulWidget {
  final List<Map<String, dynamic>> bottleItems;
  final Function(Map<String, dynamic>?) onSelected;

  const PackageSelectorComponent({
    super.key,
    required this.bottleItems,
    required this.onSelected,
  });

  @override
  State<PackageSelectorComponent> createState() =>
      _PackageSelectorComponentState();
}

class _PackageSelectorComponentState extends State<PackageSelectorComponent> {
  int _selectedIndex = -1;

  void _handleSelection(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = -1;
        widget.onSelected(null);
      } else {
        _selectedIndex = index;
        widget.onSelected(widget.bottleItems[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Package',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(widget.bottleItems.length, (index) {
            var bottle = widget.bottleItems[index];
            bool isSelected = index == _selectedIndex;

            String imageUrl = bottle['imageUrl'] ??
                'https://5.imimg.com/data5/RK/MM/MY-26385841/ff-1000x1000.jpg';

            return GestureDetector(
              onTap: () => _handleSelection(index),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 16.0),
                  child: Column(
                    children: [
                      // Bottle Image
                      Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Colors.grey,
                          );
                        },
                      ),
                      const SizedBox(height: 10),

                      // Bottle Size Text
                      Text(
                        '${bottle['size']}L ${bottle['name'] ?? "Premium"}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),

                      // Price Text
                      Text(
                        '₹${bottle['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
