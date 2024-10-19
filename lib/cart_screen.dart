import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled8/cart_model.dart';
import 'package:untitled8/payment/paymentpage.dart';
import 'package:untitled8/product_list.dart';
import 'cart_provider.dart';
import 'package:badges/badges.dart' as badges ;
import 'package:slider_button/slider_button.dart';

import 'db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(   appBar: AppBar(
      backgroundColor: Colors.blue[200],
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Row(
                                      children: [Text(
                                         snapshot.data![index].productName.toString(),
                                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),

                                        InkWell(
                                          onTap:(){
                                            dbHelper!.delete(snapshot.data![index].id!);
                                            cart.removeCounter();
                                            cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                          },
                                            child: Icon(Icons.delete))

                                      ],

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
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {

                                    int quantity =  snapshot.data![index].quantity!;
                                    int price =  snapshot.data![index].initialPrice!;
                                    quantity --;
                                    if (quantity > 0 ){

                                      int? newPrice = price* quantity;
                                      dbHelper!.updateQuantity(Cart(id: snapshot.data![index].id!,
                                          productId: snapshot.data![index].id!.toString(),
                                          productName: snapshot.data![index].productName!,
                                          initialPrice: snapshot.data![index].initialPrice!,
                                          productPrice: newPrice,
                                          quantity: quantity,
                                          unitTag: snapshot.data![index].unitTag.toString(),
                                          image: snapshot.data![index].image.toString())
                                      ).then((value){
                                        newPrice = 0;
                                        quantity =0;
                                        cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                      }).onError((error, stackTrace){
                                        print(error.toString());
                                      }
                                      );
                                    }
                                    },

                                  child: Row(
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.remove,color: Colors.white,),
                                          Text( snapshot.data![index].quantity.toString(),
                                            style: const TextStyle(color: Colors.white),),
                                          InkWell(
                                            onTap: (){
                                              int quantity =  snapshot.data![index].quantity!;
                                              int price =  snapshot.data![index].initialPrice!;
                                              quantity ++;
                                              int? newPrice = price* quantity;

                                              dbHelper!.updateQuantity(Cart(id: snapshot.data![index].id!,
                                                  productId: snapshot.data![index].id!.toString(),
                                                  productName: snapshot.data![index].productName!,
                                                  initialPrice: snapshot.data![index].initialPrice!,
                                                  productPrice: newPrice,
                                                  quantity: quantity,
                                                  unitTag: snapshot.data![index].unitTag.toString(),
                                                  image: snapshot.data![index].image.toString())
                                              ).then((value){
                                                newPrice = 0;
                                                quantity =0;
                                                cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));

                                               }).onError((error, stackTrace){
                                                print(error.toString());
                                              }
                                              );},
                                              child: Icon(Icons.add,color: Colors.white,)),
                                        ],
                                        ),
                                      ),

                                  ),

                                    ],
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
          ),
          Consumer<CartProvider>(
            builder: (context, value, child) {
              // Check if the cart is empty by comparing the total price
              bool isCartEmpty = value.getTotalPrice().toStringAsFixed(2) == "0.00";

              return isCartEmpty
                  ? Container()
                  : Column(

                     children: [
                  Visibility(
                    visible: !isCartEmpty,
                    child: Column(
                      children: [
                        ReusableWidget(
                          title: 'Sub Total',
                          value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: SliderButton(
                            action: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(),
                                ),
                              );
                              return true;
                            },
                            label: Text(
                              "Slide to pay",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            icon: Text(
                              r'$',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w400,
                                fontSize: 35,
                              ),
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ) ,
    );
  }
}
class ReusableWidget extends StatelessWidget {
  final String title , value ;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title , style: Theme.of(context).textTheme.bodyLarge,),
          Text(value.toString() , style: Theme.of(context).textTheme.bodyLarge,)
        ],
      ),
    );
  }
}