import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Auth_Provider.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/provider/proviver_product.dart';


class ProductDetail extends StatelessWidget
{
  static const routeName="/productdetails";
  
  @override
  Widget build(BuildContext context) {

    final productId=ModalRoute.of(context).settings.arguments as String;
    // TODO: implement build


   final  productObject=Provider.of<Productp>(context).item.firstWhere((prd){
     return prd.id==productId;
   });



    final cartprdt=Provider.of<Cart>(context,listen: false);

   return     ChangeNotifierProvider.value(value:Provider.of<Productp>(context).item.firstWhere((prd){
     return prd.id==productId;
   }) ,
     child:Scaffold(
   appBar: AppBar(title: Text(productObject.title)

    ,actions: <Widget>[

    Consumer<Product>(builder: (cix,product,child)=>IconButton(
    icon:Icon(product.isFavrite?Icons.favorite:Icons.favorite_border),
    onPressed: ()async {
      showDialog(context: context,builder:(ctx)=>AlertDialog(backgroundColor:Colors.amber,title: Text("${!product.isFavrite?"removed from":"added to"}  like"),elevation: 10,) );
    await product.getingfavorite(Provider.of<AuthProvider>(context,listen: false).userId,Provider.of<AuthProvider>(context,listen: false).token);



    }
    )


    )

    ,
    IconButton(icon:Icon(Icons.add_shopping_cart),
    onPressed: (){
      showDialog(context: context,builder:(ctx)=>AlertDialog(backgroundColor:Colors.amber,title: Text("added to cart"),elevation: 10,) );
    cartprdt.addCart(productObject.id,productObject.title, productObject.price,productObject.imageUrl);

    })
    ],
    ),
    body: Column(
    children: <Widget>[
    Container(
    height:300,
    width: double.infinity,
    decoration: BoxDecoration(
    border: Border.all(color:Colors.yellowAccent),

    ),
    child:ClipRRect(

    borderRadius: BorderRadius.circular(12),
    child:Image.network(productObject.imageUrl) ,
    ) ,
    ),
    SizedBox(height: 10,),
    Text("Price:- \$${productObject.price}",),
    SizedBox(height: 10,),
    Container(
    padding: EdgeInsets.all(10),
    width: double.infinity,
    child: Text("Description:- ${productObject.description}",softWrap: true,),
    alignment: Alignment.center,
    )
    ],
    ),
    ) ,);
  }



}
