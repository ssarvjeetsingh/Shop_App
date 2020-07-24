
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/orders_provider.dart';
import 'package:shop/widgets/Cart_Irem.dart';

class ShowCart extends StatelessWidget{

  static const routeName="/CartScreen";
  @override
  Widget build(BuildContext context) {

    final cartprdt=Provider.of<Cart>(context);

    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        title: Text("Your Cart"),

      ),

      body: Column(
        children: <Widget>[
          Card(
            elevation: 4,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total",style: TextStyle(fontSize: 20),),
                  Spacer(),
                  Chip(
                      label: Text("\$${cartprdt.totalAmount}"),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),

                   OrderButton(cartprdt: cartprdt,)
                ],
              ) ,
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
              child:ListView.builder(itemBuilder:(ctx,index){
              return ItemCart(Id: cartprdt.items.values.toList()[index].id,
                prdctId: cartprdt.items.keys.toList()[index],
                title: cartprdt.items.values.toList()[index].title,
                price: cartprdt.items.values.toList()[index].price,
                quantity: cartprdt.items.values.toList()[index].quantity,

              );
              },
                itemCount: cartprdt.items.length,
              )
          )
        ],
      ),
    );
  }

}


class OrderButton extends StatefulWidget{

  final Cart cartprdt;

  const OrderButton({Key key, this.cartprdt}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderButtonState();
  }

}

class OrderButtonState extends State<OrderButton>{
  var isLoading=false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   isLoading?CircularProgressIndicator():FlatButton(child: Text("Order Now!",),
        textColor: Theme.of(context).accentColor,

        onPressed:(widget.cartprdt.totalAmount<=0||isLoading)? null: ()async{
      setState(() {
        isLoading=true;
      });
          await Provider.of<Order>(context,listen: false).addOder(widget.cartprdt.items.values.toList(),widget.cartprdt.totalAmount);
          print(widget.cartprdt.items.length);
      setState(() {
        isLoading=false;
      });
           widget.cartprdt.clearCart();
        }
    );
  }

}