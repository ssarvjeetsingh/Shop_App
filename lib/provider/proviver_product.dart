
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop/httpexceptions.dart';
import 'package:shop/provider/products.dart';
import 'package:http/http.dart' as http;
import 'package:shop/screens/product_overview.dart';

class Productp with ChangeNotifier{

 // AuthProvider ob;


  List<Product> _items=[
    /*Product(
    id: 'p1',
    title: 'Red Shirt',
    description: 'A red shirt - it is pretty red!',
    price: 29.99,
    imageUrl:
    'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  //var _showfavriteonly=false;

  final String authToekn;

final  String userID;

  Productp(this.authToekn,this._items,this.userID);
  List<Product> get item
  {
    print(1);
    return [..._items];/////rtuening the copy of items not address of _items
  }

 List<Product> get FavvriteOnly
  {
    return item.where((prdct)=>prdct.isFavrite).toList();
  }

  Product findById(String id)
  {
    _items.firstWhere((prd){
      return prd.id==id;
    });
    notifyListeners();
  }



 Future<void>  addProductUser(Product newprodct) async   //using asyn all code inside wrap as future
  {

    print(newprodct.price);

    final url="https://flutterdb1-57a0a.firebaseio.com/product.json?auth=$authToekn";

  //return
    try {
      final respose=await http.post(url,body: jsonEncode({  //we can't pass object to encode so we pass map and await use to wait until this procees finished
        "createrId":userID,
        "title":newprodct.title,
        "description":newprodct.description,
        "imageurl":newprodct.imageUrl,
        "price":newprodct.price
      })
      );//.then((respose){  using async and awiat next line invisibly wrap with then block
      final newProduct=Product(
          id:json.decode(respose.body)["name"],
          title: newprodct.title,
          description: newprodct.description,
          price: newprodct.price,
          imageUrl: newprodct.imageUrl);

      _items.add(newProduct);

      print("added");
      notifyListeners();
    }catch(error){

     print(error+"hrllo");
     throw error;
  }
  }
  
  Future<void> udateByUser(String id,Product editProduct)async{
    final productindex=_items.indexWhere((prdt){
      return prdt.id==id;
    });


    if(productindex>=0)
      {
        final url="https://flutterdb1-57a0a.firebaseio.com/product/$id.json?auth=$authToekn";

       await http.patch(url,body: json.encode({

          'title':editProduct.title,
          'description':editProduct.description,
          'price':editProduct.price,
          'imageurl':editProduct.imageUrl
        }));
        _items[productindex]=editProduct;
        print(id+"hello");
        notifyListeners();
      }
    else{
      print("not exits");
    }
  }


  Future<void> fechData([bool filterByUser=false] )async{
    print("feching ");
    print(2);
    print(userID);
    final filterUser=filterByUser? '&orderBy="createrId"&equalTo="$userID"':'';
  //  print(ob.token);
    print(3);
    var url='https://flutterdb1-57a0a.firebaseio.com/product.json?auth=$authToekn$filterUser';
    print(4);
    print("feching hogyi");
    try{
      final reponse=await http.get(url);
      print("hello");
      final productFromserver=json.decode(reponse.body) as Map<String,dynamic>;
      if(productFromserver==null){
        return;
      }
      print(json.decode(reponse.body));
      url="https://flutterdb1-57a0a.firebaseio.com/userFavrites/$userID.json?auth=$authToekn";
         final favResponse= await http.get(url);

         final favData=jsonDecode(favResponse.body);
       print("hello3");
      final List<Product> productlist=[];
      productFromserver.forEach((proid,prodata){
        print("id:$proid y hai");
      productlist.add( Product(
          id: proid,
          title: prodata['title'],
          description: prodata['description'],
          imageUrl: prodata['imageurl'],
          price: prodata['price'],
          isFavrite: favData==null ? false:favData[proid] ?? false,
        )

      );
        print(5);
      });
      print(6);
      _items=productlist;
      print(7);
    notifyListeners();
      print(8);
    }catch(error){
      print("hello5$error");

    }

  }
  Future<void >deleteByUser(String id) async {
    final url="https://flutterdb1-57a0a.firebaseio.com/product/$id.json?auth=$authToekn";

    final itemproductindex=_items.indexOf(_items.firstWhere((prd){
      return prd.id==id;
    }));

    var exititem=_items[itemproductindex];

    _items.removeAt(itemproductindex);
    notifyListeners();
    final response=await http.delete(url);

      if(response.statusCode>=400)
      {
        _items.insert(itemproductindex, exititem);
        notifyListeners();

        throw HttpException("could not deleted");
      }
      exititem=null;

  }
 // void showfavonly()
  //{
   // _showfavriteonly=true;
   // notifyListeners();
  //}
  //void showall()
  //{
    //_showfavriteonly=false;
    //notifyListeners();
  //}
}