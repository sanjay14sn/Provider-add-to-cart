import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled8/cart_model.dart';
import 'package:untitled8/cart_provider.dart';
import 'package:untitled8/cart_screen.dart';
import 'package:untitled8/db_helper.dart';
import 'package:badges/badges.dart' as badges ;


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  DBHelper? dbHelper = DBHelper();


  List<String> productName = ['Donuts', 'Pizza', 'Cake', 'Grapes', 'Apple', 'Orange'];
  List<String> productUnit = ['Piece', 'Piece', 'Piece', 'KG', 'KG', 'KG'];
  List<int> productPrice = [50, 60, 70, 80, 90, 100];
  List<String> productImage = [
    'assetss/donuts.jpg.jpg',
    'assetss/pizza.jpg.jpg',
    'assetss/cake.jpg.jpg',
    'assetss/Grapes.jpg.jpg',
    'assetss/Apple.jpg.jpg',
    'assetss/Orange.jpg.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('Product List'),
        centerTitle: true,
        actions: [
          SizedBox(
            child: Center(
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 20),
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                badgeAnimation: badges.BadgeAnimation.slide(
                  animationDuration: const Duration(milliseconds: 200),
                ),
                badgeStyle: badges.BadgeStyle(
                  padding: EdgeInsets.all(6),
                ),
                child: SizedBox(
                  width: 100,
                  child: IconButton(
                    icon: const Icon(Icons.shopping_bag),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          height: 100,
                          width: 100,
                          image: AssetImage(productImage[index]),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName[index],
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${productUnit[index]}  \$${productPrice[index]}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () async {
                              print("Add to Cart tapped");
                              List<Cart> cartItems = await cart.getData();
                              print("Fetched Cart Items: ${cartItems.length}");

                              bool alreadyInCart = cartItems.any((item) => item.productId == productImage[index]);
                              print("Already in Cart: $alreadyInCart"); // Log statement

                              if (alreadyInCart) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Already in Cart"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                await dbHelper!.insert(
                                  Cart(
                                    id: index,
                                    productId: index.toString(),
                                    productName: productName[index],
                                    initialPrice: productPrice[index],
                                    productPrice: productPrice[index],
                                    quantity: 1,
                                    unitTag: productUnit[index],
                                    image: productImage[index],
                                  ),
                                );

                                cart.addTotalPrice(productPrice[index].toDouble());
                                cart.addCounter();

                                print("Product Added to Cart");
                              }
                            },




                            child: Container(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Add To Cart',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),


        ],
      ),
    );
  }
}


