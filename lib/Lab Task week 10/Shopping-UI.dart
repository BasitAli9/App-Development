import 'package:flutter/material.dart';

void main() {
  runApp(MyShopApp());
}

class MyShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop UI App',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {"name": "T-Shirt", "price": "\$20", "image": "assets/images/tshirt.png"},
    {"name": "Jeans", "price": "\$35", "image": "assets/images/jeans.png"},
    {"name": "Shoes", "price": "\$50", "image": "assets/images/shoes.png"},
    {"name": "Watch", "price": "\$60", "image": "assets/images/watch.png"},
    {"name": "Cap", "price": "\$10", "image": "assets/images/cap.png"},
    {"name": "Bag", "price": "\$40", "image": "assets/images/bag.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Safe Area + SliverAppBar
          SliverSafeArea(
            sliver: SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('🛍 MyShop'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.deepPurpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // SliverList for Cards
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final item = products[index];
                return Dismissible(
                  key: Key(item["name"]),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item["name"]} removed')),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Image.asset(item["image"], height: 50, width: 50, fit: BoxFit.cover),
                      title: Text(item["name"]),
                      subtitle: Text("Price: ${item["price"]}"),
                      trailing: Icon(Icons.shopping_cart_checkout),
                    ),
                  ),
                );
              },
              childCount: products.length,
            ),
          ),

          // SliverGrid for product grid
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final item = products[index];
                return Stack(
                  children: [
                    Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(item["image"], height: 80, fit: BoxFit.contain),
                          SizedBox(height: 10),
                          Text(item["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(item["price"], style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Icon(Icons.favorite_border, color: Colors.pinkAccent),
                    ),
                  ],
                );
              },
              childCount: products.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          ),
        ],
      ),
    );
  }
}