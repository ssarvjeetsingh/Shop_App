
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/provider/orders_provider.dart';


class OrderItem extends StatefulWidget
{
  final OrderItems items;

  const OrderItem(this.items);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StateOrderItem();
  }

}

class StateOrderItem extends State<OrderItem>{
  bool isExpanded=false;
  @override
  Widget build(BuildContext context) {
    print(widget.items);
    // TODO: implement build
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$${widget.items.amount}"),
            subtitle: Text(DateFormat("dd/MM/yyyy hh:mm").format(widget.items.date)),
            trailing: Icon(isExpanded?Icons.expand_less:Icons.expand_more,),
            onTap: (){
              setState(() {
                isExpanded=!isExpanded;
              });

            },
          ),
          if(isExpanded)
              Container(
                height: min(widget.items.product.length*20.0 +100,180),
                child:ListView.builder(itemCount: widget.items.product.length,

                itemBuilder: (ctx,index){
                  print(widget.items.product[index].title+"jio");
                  return ListTile(
                    leading: CircleAvatar(
                      child: Container
                        (child:
                      Image.network(widget.items.product[index].image),


                      )
                    ),
                    title: Text(widget.items.product[index].title),//,
                    subtitle:Text(widget.items.date.toString()),
                    trailing: Text("quan${widget.items.product[index].quantity}x \$${widget.items.product[index].price}"),
                  );

                },
                ) ,
              )

        ],

      ),
    );
  }

}