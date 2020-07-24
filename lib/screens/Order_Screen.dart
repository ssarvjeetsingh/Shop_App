import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Auth_Provider.dart';
import 'package:shop/provider/orders_provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/orter_items.dart';

/*class OrderScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderScreenState();
  }
}*/

class OrderScreen extends StatelessWidget{
  static const routeName="orderscreen";
 // var isLoading=false;
  @override
 /* void initState() {

  //Future.delayed(Duration.zero).then((_) async{
//    setState(() {
      isLoading=true;
  //  });
     Provider.of<Order>(context,listen: false).fetchAndSetOrder().then((_){
       setState(() {
         isLoading=false;
       });

     });

  //});
    // TODO: implement initState
    super.initState();
  }*/
  @override
  Widget build(BuildContext context) {
    //final orderData=Provider.of<Order>(context);
    print("run");
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDraw(),
      body:FutureBuilder(future:Provider.of<Order>(context,listen: false).fetchAndSetOrder(),  //future builder helps to not build entire build methode
          builder: (ctx,snapshotdata){
        if(snapshotdata.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else
          if(snapshotdata.error!=null){
            return Text("sorry ${snapshotdata.error}");
          }
          else{
            return Consumer<Order>(builder:(ctx,orderData,child)=>ListView.builder(itemCount: orderData.oritem.length,
              itemBuilder: (ctx,index){
                return OrderItem(orderData.oritem[index]);
              },

            ) ,
            );
          }
          })//isLoading?Center(child: CircularProgressIndicator(),):Consumer<Order>(builder:(ctx,orderData,child)=>ListView.builder(itemCount: orderData.oritem.length,
        //itemBuilder: (ctx,index){
          //return OrderItem(orderData.oritem[index]);
        //},

     // ) ,)
    );
  }

}