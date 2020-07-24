import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/proviver_product.dart';
import 'package:shop/screens/Product_edit_Screen.dart';
class ProductUser extends StatelessWidget{
  final String title,image,id;
  const ProductUser(this.title, this.image,this.id);
  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    final product=Provider.of<Productp>(context,listen: false);
    // TODO: implement build
    return ListTile(
      title:Text(title) ,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
      trailing: Container(
        width: 100,
          child:Row(children: <Widget>[
        IconButton(icon: Icon(Icons.edit),onPressed: (){
          Navigator.of(context).pushNamed(EditPrdct.routeName,arguments: id);
        },color: Theme.of(context).accentColor,),
        IconButton(icon: Icon(Icons.delete),
          onPressed: ()async {
          try{
            await product.deleteByUser(id);
          }
          catch(error){

            scaffold.showSnackBar(SnackBar(content: Text("deletion failed")));
          }

        },color: Theme.of(context).errorColor,)
      ],
          ),
      )
    );
  }
}