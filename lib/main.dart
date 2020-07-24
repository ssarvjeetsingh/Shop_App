import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Auth_Provider.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/orders_provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/OffScreen.dart';
import 'package:shop/screens/Order_Screen.dart';
import 'package:shop/screens/Product_edit_Screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overview.dart';
import 'package:shop/screens/splash_Screen.dart';
import 'package:shop/screens/user_product_screen.dart';
import 'provider/proviver_product.dart';
void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(providers: [
      ChangeNotifierProvider(
         create: (ctx)=>AuthProvider(),
      ),
      ChangeNotifierProxyProvider<AuthProvider,Productp>(
        update:(ctx,authPro,prevoudProducts)=>Productp
          (authPro.token, prevoudProducts==null?[]:prevoudProducts.item,authPro.userId) ,
      ),
      ChangeNotifierProvider(
        create:(ctx)=>Cart() ,
      ),
      ChangeNotifierProxyProvider<AuthProvider,Order>(  //instead of simple provider

        update: (ctx,auth,prevousOrder)=>Order(auth.token,prevousOrder==null?[]:prevousOrder.orderitems,auth.userId) ,
      ),
      ChangeNotifierProvider(
        create:(ctx)=>Product() ,
      )
    ],
      child:Consumer<AuthProvider>(builder:(ctx,auth,child)=>

          MaterialApp(
            title: "It's Lit",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.yellow,
                accentColor: Colors.deepPurple,
                fontFamily: 'Lato'
            ),

            home:auth.isAuthenticity?ProductOverView(): FutureBuilder(
              future: auth.tryAutoLogin(),
                builder: (ctx,snapshotData)=> snapshotData.connectionState==ConnectionState.waiting?SplashScreen():AuthScreen()),
            routes: {
              //ProductOverView.routeName:(ctx) =>ProductOverView(),
              ProductDetail.routeName: (ctx) => ProductDetail(),
              ShowCart.routeName:(ctx)=>ShowCart(),
              OrderScreen.routeName:(ctx)=>OrderScreen(),
              UserProducts.routeName:(ctx)=>UserProducts(),
              EditPrdct.routeName:(ctx)=>EditPrdct()
            },
          ),
      )
    );
  }
}