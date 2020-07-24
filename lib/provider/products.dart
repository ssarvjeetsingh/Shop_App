
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/httpexceptions.dart';
class Product with ChangeNotifier {

  final String id;
  final String description;
  final String title;
  final double price;
  final String imageUrl;
  bool isFavrite=false;

  Product(
      {this.id,
        this.description,
        this.title,
        this.price,
        this.imageUrl,
        this.isFavrite=false}
        );

  Future<String> getingfavorite (String userId,String authToken) async
  {
    print(id);
    isFavrite=!isFavrite;
    notifyListeners();
    var url="https://flutterdb1-57a0a.firebaseio.com/userFavrites/$userId/$id.json?auth=$authToken";


    final response=  await http.put(url,body: json.encode(
        isFavrite
      ));

    if(response.statusCode>=400) {
      isFavrite=!isFavrite;

      notifyListeners();

    throw HttpException(!isFavrite?"Can't Add":"Can't Remove");
    }
    return isFavrite?"Add to Favrite":"Remove from Favrite";

  }

}