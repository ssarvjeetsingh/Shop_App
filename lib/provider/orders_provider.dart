
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shop/provider/Cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop/provider/products.dart';

class OrderItems{
  final String id;
  final double amount;
  final List<CartItem> product;
  final DateTime date;
  OrderItems(
  {
  @required this.id,
  @required this.amount,
  @required this.product,
  @required this.date});
}
class Order with ChangeNotifier {
  List<OrderItems> orderitems=[];
  List<CartItem> newOb=[];
  List<OrderItems> get oritem {
    return [...orderitems];
  }
 final String authToken;
  final String userId;
  Order(this.authToken,this.orderitems,this.userId);


  Future<void> fetchAndSetOrder()async{
    List<OrderItems> loadedItems=[];
    final url="https://flutterdb1-57a0a.firebaseio.com/Order/$userId.json?auth=$authToken";

   final response=await http.get(url);

   final extractedData=jsonDecode(response.body)as Map<String,dynamic>;
   if(extractedData==null){
     return;
   }
   extractedData.forEach((orderId,orderData){
     loadedItems.add(OrderItems(
         id: orderId,
         amount:orderData['totalamount'] ,
         product:(orderData["products"] as List<dynamic>).map((item){

           return  CartItem(
             id: item["id"],
             image: item["imageurl"],
             price:item["price"],
             quantity: item["quantity"],
             title:item["title"]
           );

         }).toList() ,
         date: DateTime.parse(orderData["datetime"])));
   });



   orderitems=loadedItems;

   orderitems.forEach((test){
     print("${test.product.length} product length");
     print("${test.product}");
     print("heelo");


   });
   notifyListeners();

  }


  Future<void> addOder(List<CartItem> citem, double totalprice)async {

    citem.forEach((test){
      print(test.title);
      print(test.price);
      print(test.quantity);

    });
    final timestamp=DateTime.now();
    final url="https://flutterdb1-57a0a.firebaseio.com/Order/$userId.json?auth=$authToken";
  final response=await  http.post(url,body:jsonEncode({
      "totalamount":totalprice,
      "datetime":timestamp.toIso8601String(),
      "products":citem.map((cartitem)=>{

        "id":cartitem.id,
        "title":cartitem.title,
        "price":cartitem.price,
        "quantity":cartitem.quantity,
        "imageurl":cartitem.image
      }).toList()
    }));


orderitems.insert(0,
    OrderItems(
        id: jsonDecode(response.body)["name"],
    product: citem,
        amount: totalprice,
        date: timestamp
    ));

      notifyListeners();

  }
}