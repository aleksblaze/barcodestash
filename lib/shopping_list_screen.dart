import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_provider.dart';
import 'shopping_item.dart';

class ShoppingListScreen extends StatelessWidget {
  final String listId;

  ShoppingListScreen({required this.listId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Consumer<ShoppingProvider>(
          builder: (context, provider, child) {
            final list =
                provider.shoppingLists.firstWhere((list) => list.id == listId);
            final sortedItems = List<ShoppingItem>.from(list.items)
                     ..sort((a, b) => a.isBought ? 1 : -1);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: const Padding(
                          padding: EdgeInsets.only(left: 70.0),
                          child: Text(
                            'Shopping List',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: 'Barlow',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedItems.length,
                    itemBuilder: (context, index) {
                      final item = sortedItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            height: 70,
                            child: ListTile(
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: item.isBought
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                                trailing: Checkbox(
                                value: item.isBought,
                                activeColor: Colors.black, // Change the color here
                                onChanged: (value) {
                                  if (item.isBought) {
                                  provider.toggleItemBought(list.id, item.id, 0, 0.0);
                                  } else {
                                  _showQuantityPriceDialog(
                                    context, provider, list.id, item.id);
                                  }
                                },
                                ),
                              contentPadding: EdgeInsets.only(bottom: 4),
                              horizontalTitleGap: 0,
                              minVerticalPadding: 0,
                              dense: true,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: ElevatedButton(
                  onPressed: () {
                    provider.completePurchase(list.id);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    'End purchase',
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        backgroundColor: Colors.black,
        mini: true,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add item',
              style: TextStyle(color: Colors.black, fontFamily: 'Barlow')),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Item name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',
                  style: TextStyle(color: Colors.black, fontFamily: 'Barlow')),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Provider.of<ShoppingProvider>(context, listen: false)
                      .addShoppingItem(listId, controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add',
                  style: TextStyle(color: Colors.black, fontFamily: 'Barlow')),
            ),
          ],
        );
      },
    );
  }

  void _showQuantityPriceDialog(BuildContext context, ShoppingProvider provider,
      String listId, String itemId) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter quantity and price',
              style: TextStyle(color: Colors.black, fontFamily: 'Barlow')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                decoration: InputDecoration(hintText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(hintText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',
                  style: TextStyle(color: Colors.black, fontFamily: 'Barlow')),
            ),
            TextButton(
              onPressed: () {
                final quantity = int.tryParse(quantityController.text) ?? 1;
                final price = double.tryParse(priceController.text) ?? 0.0;
                provider.toggleItemBought(listId, itemId, quantity, price);
                Navigator.of(context).pop();
              },
              child: Text('Save',
                  style: TextStyle(color: Colors.black, fontFamily: 'Barlow')),
            ),
          ],
        );
      },
    );
  }
}
