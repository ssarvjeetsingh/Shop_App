import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/httpexceptions.dart';
class AuthProvider with ChangeNotifier{
String Token;
DateTime expiryToken;
String UserId;
Timer authTime;
String userMail;
bool get isAuthenticity{

  return Token!=null;
}

String get mail{
  if(expiryToken!=null&&Token!=null&&expiryToken.isAfter(DateTime.now())){
    return userMail;
  }
  return  '';
}

String get token{
  if(expiryToken!=null&&Token!=null&&expiryToken.isAfter(DateTime.now())){
    return Token;
  }
  return  null;
}

String get userId
{
  return UserId;
}

Future<void>  _authenication(String email,String password,String urlSegment)async{

  final url="https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC-xb3QquKUqSCKIPm-4lR6HD3KdFfrT5U";
  print(urlSegment);
  try{
    final response= await http.post(url,body:jsonEncode(
        {'email':email,
          'password':password,
          'returnSecureToken':true}

    ));

    final responsedata=json.decode(response.body);
    if(responsedata['error']!=null){
       print("hello");
      throw HttpException(responsedata["error"]["message"]);
    }
    Token=responsedata["idToken"];
    UserId=responsedata["localId"];
    expiryToken=DateTime.now().add(Duration(seconds:int.parse(responsedata['expiresIn'])));
    userMail=responsedata["email"];
_autoLogOut();
 notifyListeners();
 final pref= await SharedPreferences.getInstance();
final userData=json.encode({"token":Token,"expireDate":expiryToken.toIso8601String(),"userId":UserId});
pref.setString("userdata", userData);

  }catch(error){
    throw(error);
  }

}
Future<bool> tryAutoLogin() async
{
  final pref=await SharedPreferences.getInstance();

  if(!pref.containsKey("userdata")){
    return false;
  }
   final extraxtedData=jsonDecode(pref.get("userdata"))as Map<String,dynamic>;
   final expireDate=DateTime.parse(extraxtedData["expireDate"]);


  if(expireDate.isBefore(DateTime.now()))
    {
      return false;
    }

  Token=extraxtedData["token"];
  expiryToken=expireDate;
  UserId=extraxtedData["userId"];

  notifyListeners();
  _autoLogOut();
  return true;

}

Future <void> signUp(String email,String Password)async
{

  return _authenication(email, Password, "signUp");
}


Future <void> LogIn(String email,String password) async{
 // final url="https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC-xb3QquKUqSCKIPm-4lR6HD3KdFfrT5U";
  return _authenication(email, password, "signInWithPassword");

}

Future<void> logOut() async
{
  Token=null;
  expiryToken=null;
  UserId=null;
  if(authTime!=null){
    authTime.cancel();
    authTime=null;
  }
  notifyListeners();

  final pref=await SharedPreferences.getInstance();
  pref.clear();

}


void _autoLogOut(){
if(authTime!=null)
  {
   authTime.cancel();
  }
  final expireTiming=expiryToken.difference(DateTime.now()).inSeconds;
print(expireTiming);
  authTime=Timer(Duration(seconds: expireTiming), logOut);

}

}