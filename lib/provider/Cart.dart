

import 'package:flutter/cupertino.dart';


class CartItem {

  final String id;
  final String title;
  final double price;
  final int quantity;
  final String image;

  CartItem({this.id, this.title, this.price, this.quantity,this.image});


}

class Cart with ChangeNotifier{


  Map<String,CartItem> _itemprt={};


  Map<String,CartItem> get items{
    return {..._itemprt};
  }

  int get itemCount{

    return _itemprt.length;
  }

    void addCart(String pid,String ptitle,double pprice,String img)
    {

      if(_itemprt.containsKey(pid))
        {
             print("add 1");
          _itemprt.update(pid, (existprdt)=>CartItem(
            id:existprdt.id,
            title: existprdt.title,
            price: existprdt.price,
            quantity: existprdt.quantity+1,
              image: existprdt.image
          )
          );
        }
      else
        {
          _itemprt.putIfAbsent(pid,()=> CartItem(

              id: DateTime.now().toString(),
              title: ptitle,
              price: pprice,
              quantity: 1,
              image: img
          )

          );

          notifyListeners();
        }
    }


    double get totalAmount{
    print('get total');
    double total=0.0;
    _itemprt.forEach((key,items){
      total +=items.price*items.quantity;

    });
    print(total);
        return total;

    }

    void removeCart(String id)
    {
      _itemprt.remove(id);
      notifyListeners();
    }

   void removeOnUndo(String id)
   {
     if(!_itemprt.containsKey(id))
       {
         return;
       }
     if(_itemprt[id].quantity>1)
       {
         _itemprt.update(id, (exitingcartprdt){
           return CartItem(
               id: exitingcartprdt.id,
               title: exitingcartprdt.title,
               image: exitingcartprdt.image,
           price: exitingcartprdt.price,
           quantity: exitingcartprdt.quantity-1);
         });
       }
     else
       {
         _itemprt.remove(id);

       }
     notifyListeners();

   }
      void clearCart()
      {
        _itemprt={};
        notifyListeners();
      }


}