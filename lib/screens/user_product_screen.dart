
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/proviver_product.dart';
import 'package:shop/screens/Product_edit_Screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product.dart';




class UserProducts extends StatelessWidget{
  static const routeName = "/user_product";
  //var isLoading=false;

  /*initState ()  ////can be use using statefull widget
  {
    isLoading=true;
    Future.delayed(Duration.zero).then((_)async{
      await Provider.of<Productp>(context,listen: false).fechData(true);
      setState(() {
        isLoading=false;
      });
    });

    super.initState();
  }*/
  Future<void> onRefresh(BuildContext context) async{
     await Provider.of<Productp>(context,listen: false).fechData(true);
  }
  @override
  Widget build(BuildContext context) {
 print("rebulid");
    //final products=Provider.of<Productp>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),
              onPressed: (){
                 Navigator.of(context).pushNamed(EditPrdct.routeName);
              }
              )
        ],
      ),
        drawer: AppDraw(),
      body:FutureBuilder(
        future:onRefresh(context) ,
      builder: (ctx,snapshotData){
         if(snapshotData.connectionState==ConnectionState.waiting){
           return Center(child: CircularProgressIndicator(),);
         }
         else{
           return RefreshIndicator(
             onRefresh: (){
               return onRefresh(context);
             },
             child:Consumer<Productp>(builder: (ctx,products,_)=>Padding(padding:EdgeInsets.all(8) ,
               child:ListView.builder(
                   itemCount:products.item.length,

                   itemBuilder:(ctx,index){

                     return Column(children: <Widget>[

                       ProductUser(products.item[index].title,products.item[index].imageUrl,products.item[index].id),
                       Divider()
                     ],);

                   }
               ),
             ) ,)
           );
         }
      },
      )
    );
  }

}