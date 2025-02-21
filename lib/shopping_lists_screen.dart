import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_provider.dart';
import 'shopping_list_screen.dart';

class ShoppingListsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Shopping lists',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
                    Expanded(
                    child: Consumer<ShoppingProvider>(
                      builder: (context, provider, child) {
                      return ListView.builder(
                        itemCount: provider.shoppingLists.length,
                        itemBuilder: (context, index) {
                        final list = provider.shoppingLists[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
                          child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            height: 70,
                            child: ListTile(
                            title: Text(list.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  ShoppingListScreen(listId: list.id),
                              ),
                              );
                            },
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
                      );
                      },
                    ),
                    ),
            ],
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Container(
              width: 28.0, // Set the width of the button
              height: 28.0, // Set the height of the button
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white, size: 20),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  _showAddListDialog(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddListDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add new list',
              style: TextStyle(color: Colors.black, fontFamily: 'Barlow')),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'List name',
            ),
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
                      .addShoppingList(controller.text);
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
}
