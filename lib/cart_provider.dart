import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled8/db_helper.dart';
import 'cart_model.dart';

class CartProvider with ChangeNotifier {
  DBHelper db = DBHelper();

  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  CartProvider() {
    _getPrefItems();
    _cart = db.getCartList();
    print("CartProvider initialized: counter=$_counter");
  }

  Future<List<Cart>> getData() async {
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    print("Preferences set: counter=$_counter, totalPrice=$_totalPrice");
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;

    if (_counter < 0) {
      _counter = 0;
      _setPrefItems(); // Reset preferences if needed
    }

    if (_totalPrice < 0) {
      _totalPrice = 0.0;
      _setPrefItems();
    }
    notifyListeners();
    print("Preferences fetched: counter=$_counter, totalPrice=$_totalPrice");
  }

  void addTotalPrice(double productPrice) {
    _totalPrice += productPrice;
    if (_totalPrice < 0) {
      _totalPrice = 0.0;
    }
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice -= productPrice;
    if (_totalPrice < 0) {
      _totalPrice = 0.0;
    }
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice() {
    return _totalPrice;
  }

  void addCounter() {
    _counter++;
    if (_counter < 0) {
      _counter = 0;
    }
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    if (_counter < 0) {
      _counter = 0;
    }
    _setPrefItems();
    notifyListeners();
  }

  int getCounter() {
    print("getCounter called: counter=$_counter");
    return _counter;
  }
}
