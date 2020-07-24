

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Auth_Provider.dart';
import 'package:shop/screens/Order_Screen.dart';
import 'package:shop/screens/user_product_screen.dart';

class AppDraw extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(title: Text(Provider.of<AuthProvider>(context,listen: false).userMail==null?'':Provider.of<AuthProvider>(context,listen: false).userMail),
          automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Your Products"),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProducts.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: (){

               Navigator.of(context).pop();
               Navigator.of(context).pushReplacementNamed("/");
              Provider.of<AuthProvider>(context,listen: false).logOut();
            },
          )
        ],

      ),
    );
  }

}