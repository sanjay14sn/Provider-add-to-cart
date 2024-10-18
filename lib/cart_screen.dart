import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled8/cart_model.dart';
import 'cart_provider.dart';
import 'package:badges/badges.dart' as badges ;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(   appBar: AppBar(
      title: const Text('MY Cart'),
      centerTitle: true,
      actions: [
        Center(
          child: badges.Badge(
            position:badges.BadgePosition.topEnd(top: 0, end: 5),
            badgeContent: Consumer<CartProvider>(builder:(context,value,child){
              return Text(value.getCounter().toString(),style:TextStyle(color:Colors.white),);
            },
            ),
            badgeAnimation:badges.BadgeAnimation.slide(

                animationDuration:Duration(milliseconds:200)),
            child: IconButton(
              icon: const Icon(Icons.shopping_bag),
              onPressed: () {
                // Action for the shopping cart button
              },
            ),
          ),
        ),
      ],
    ),
      body:Column(
        children: [
          FutureBuilder(
              future:cart.getData(),
              builder: (context ,AsyncSnapshot<List<Cart>> snapshot){
                if (snapshot.hasData){
                  return Expanded(child: ListView.builder(
                    itemCount: snapshot.data!.length,
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
                                image: AssetImage(snapshot.data![index].image.toString()),
                              ),
                              const SizedBox(width: 10), // Add space between image and text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].productName.toString(),
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        snapshot.data![index].unitTag.toString()+" "+r"$"+snapshot.data![index].productPrice.toString(),
                                      style: const TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              //Spacer(), // This will push the button to the right
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {},
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
                  );
                }
                return Text('');
              }
          )
        ],
      ) ,
    );
  }
}
