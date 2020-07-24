import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Cart.dart';

class ItemCart extends StatelessWidget
{

  final String Id;
  final String title;
  final int quantity;
  final double price;
  final String prdctId;

  const ItemCart({ this.Id, this.title, this.quantity, this.price,this.prdctId});


  @override
  Widget build(BuildContext context) {
    print(prdctId);
    // TODO: implement build
    return Dismissible(key:ValueKey(Id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,color: Theme.of(context).accentColor,size: 40,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4) ,
      ),
      direction: DismissDirection.endToStart,
        confirmDismiss:(direction){
     return showDialog(context: context,
          builder: (ctx)=>AlertDialog(
            title:Text("Are you Sure?"),
        content: Text("Do youu want to remove this item from cart"),
            actions: <Widget>[
              FlatButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("No",style: TextStyle(color:Theme.of(context).accentColor),)),
              FlatButton(onPressed: (){Navigator.of(context).pop(true);}, child: Text("Yes",style: TextStyle(color:Theme.of(context).accentColor)))
            ],
          )
     );

        },
        onDismissed: (direction){
          Provider.of<Cart>(context,listen: false).removeCart(prdctId);
        },
      child: Card(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child:ListTile(
          leading: CircleAvatar(child:Padding(padding: EdgeInsets.all(5),child:FittedBox(child: Text('\$$price',) ,) ,),backgroundColor: Theme.of(context).accentColor,),
          title: Text(title),
          subtitle: Text("Total \$ ${price*quantity}"),
          trailing:Text("$quantity x"),

        ) ,

      ),

    ),
    );
  }

}