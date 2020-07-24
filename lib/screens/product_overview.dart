
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/proviver_product.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/Product_gridview.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';

enum popup{
  favrite,
  all
}

class ProductOverView extends StatefulWidget
{

  //static const routeName="/overview";
  static const rootRoute='/';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StateProductOverView();
  }

}

class StateProductOverView extends State<ProductOverView>
{
  var isLoading=false;
   //var isChange=true;
 /* @override
  void didChangeDependencies() {

    if(isChange)
      {
        Provider.of<Productp>(context,listen: false).fechData().then((_){
          print("false hone wala h");
          setState(() {
            isLoading=false;
          });
        })  ;
      }
    isChange=false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }*/

  @override
  void initState() {
    print("over");

      print("true hogya");
      isLoading=true;
    // TODO: implement initState
     Provider.of<Productp>(context,listen: false).fechData().then((_){
       print("false hone wala h");
       setState(() {
         isLoading=false;
       });
     }
    );

    super.initState();
  }
    var _showonly=false;
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("It's Lit"),
        actions: <Widget>[
          PopupMenuButton(
                onSelected: (popup selectedvalue){
                  setState(() {
                    if(selectedvalue==popup.favrite)
                    {
                      _showonly=true;
                    }
                    else
                    {
                      _showonly=false;
                    }
                  });

                },
              icon:Icon(Icons.more_vert),itemBuilder:(_){

            return[
              PopupMenuItem(child:Text("only favrites") ,value: popup.favrite,),
              PopupMenuItem(child:Text("all products") ,value: popup.all,),
            ];
          }),
          Consumer<Cart>(
              builder:(_,cartdata,ch)=>Badge(
                  child: ch,  //this ch is child of consumer which is IconButton below
                  value: cartdata.itemCount.toString(), //this will change when we add prdt to cart
              ),
               child: IconButton(icon: Icon(Icons.shopping_cart),
                   onPressed: (){
                 Navigator.of(context).pushNamed(
                   ShowCart.routeName);

                   }), //this icon not want to te built we refer as child of builder of consumer
          )
        ],
      ),
      drawer: AppDraw(),
      body: isLoading?Center(child: CircularProgressIndicator(),):ProductGrid(_showonly),
    );
  }

}