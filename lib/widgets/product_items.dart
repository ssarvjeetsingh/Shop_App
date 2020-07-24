import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Auth_Provider.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/product_detail_screen.dart';

class ProductItmes extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
   final scaffold=Scaffold.of(context);
    final productitem=Provider.of<Product>(context,listen: false);
    final cartprdt=Provider.of<Cart>(context,listen: false);
    // TODO: implement build
  //print("rebuid");
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child:GridTile(
        child:GestureDetector(
          onTap: (){

            Navigator.of(context).pushNamed(
                ProductDetail.routeName,arguments: productitem.id

            );
          },
          child:Image.network(productitem.imageUrl,fit: BoxFit.cover,) ,) ,

        footer:GridTileBar(title:Text(productitem.title,textAlign: TextAlign.center,),
            backgroundColor: Colors.black87,
            leading:Consumer<Product>//use consumer to rebuilt only particular widget of builder method
              (builder: (ctx,product,child)=>IconButton(
              icon: Icon(product.isFavrite?Icons.favorite:Icons.favorite_border),
              onPressed: ()async{
                scaffold.hideCurrentSnackBar();
                var status=!product.isFavrite?"added":"removed";
                try{
                  scaffold.showSnackBar(SnackBar(content: Text("${status} ",textAlign: TextAlign.center,)),);
                  status=   await product.getingfavorite(Provider.of<AuthProvider>(context,listen: false).userId,Provider.of<AuthProvider>(context,listen: false).token);

                }catch(error){
                  scaffold.showSnackBar(SnackBar(content: Text("${error} ",textAlign: TextAlign.center,)),);
                }

              },
              color: Theme.of(context).accentColor,),

            ) ,
            trailing: IconButton(icon: Icon(Icons.shopping_cart),
                onPressed: (){

                  cartprdt.addCart(productitem.id, productitem.title, productitem.price,productitem.imageUrl);

                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("added to cart"),
                        action:SnackBarAction(label: 'Undo', onPressed: (){
                          cartprdt.removeOnUndo(productitem.id);
                        }) ,
                        duration:Duration(seconds: 2) ,
                      )
                  );
                },color: Theme.of(context).accentColor)

        ),

      ),

      ) ;
  }
}