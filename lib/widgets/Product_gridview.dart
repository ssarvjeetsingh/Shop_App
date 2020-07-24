
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/proviver_product.dart';
import 'package:shop/widgets/product_items.dart';

class ProductGrid extends StatelessWidget{
  final showfav;

   ProductGrid(this.showfav);
  @override
  Widget build(BuildContext context) {
   final productpObj=Provider.of<Productp>(context);
    final productlist=showfav?productpObj.FavvriteOnly:productpObj.item;
    // TODO: implement build
    return GridView.builder(

      padding: const EdgeInsets.all(10.0),
      itemBuilder: (cxt,index){
        return ChangeNotifierProvider.value(
          value:productlist[index],
        child:ProductItmes(

            //productlist[index].id,
            //productlist[index].imageUrl,
            //productlist[index].title
        ),
        );
      },
      itemCount: productlist.length,

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,

      ),

    );
  }


}