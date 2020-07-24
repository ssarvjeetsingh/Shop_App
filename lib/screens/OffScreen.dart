import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Auth_Provider.dart';
import 'package:shop/httpexceptions.dart';
enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'It\'s Lit!',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController _animationController;
  Animation<Size> _hightanimation;
  var _isLoading = false;
  final _passwordController = TextEditingController();


@override
  void initState() {
    // TODO: implement initState
  _animationController=AnimationController(
      vsync: this,duration:Duration(milliseconds: 300) //this controller control the animation
  );

  _hightanimation=Tween<Size>(begin: Size(double.infinity, 260),end:Size(double.infinity, 320)).animate(
      CurvedAnimation(parent:_animationController, curve: Curves.fastOutSlowIn)
  );//this generic class class perorm how to animate
  // b/w two value it does't make animation it contains only information how animation will perform

  //_hightanimation.addListener((){
 // setState(() {
  //});
  //});
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  void showErrorDialog(String message){

    showDialog(context:context,builder: (ctx)=>AlertDialog(
      title:Text("Something Wrong"),
      content:Text(message),
      actions: <Widget>[
        FlatButton(onPressed: ()=>Navigator.of(context).pop(),
            child: Text("Ok",style: TextStyle(color: Theme.of(context).accentColor),)
        )
      ]
      ,)

    );
  }



  Future<void> _submit() async{
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try{
    if (_authMode == AuthMode.Login) {
      // Log user in

        await Provider.of<AuthProvider>(context,listen: false).LogIn(_authData["email"], _authData["password"]);

    }
    else {
      // Sign user up

        await Provider.of<AuthProvider>(context, listen: false).signUp(
            _authData["email"], _authData["password"]);
      }

    }on HttpException catch(error){
      print("heelo2");

      var errormessage="Could not Authenticat you";

      if(error.tooString().contains("EMAIL_EXISTS"))
        {
          errormessage="this mail already exits";
        }
      else if(error.tooString().contains("INVALID_EMAIL")){
        errormessage="This mail not valid";
      }
      else if(error.tooString().contains("WEAK_PASSWORD")){
        errormessage="Password is too weak";
      }
      else if(error.tooString().contains("INVALID_PASSWORD")){
        errormessage="Invalid Paddword";
      }
      else if(error.tooString().contains("EMAIL_NOT_FOUND")){
        errormessage="can not found this Email";
      }
      showErrorDialog(errormessage);

    }
    catch(error){
      var errorMessage="Sorry Please try again later!";
    showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _animationController.forward(); //stars the animation
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child:AnimatedBuilder(animation: _hightanimation, builder:
          (ctx,ch)=>Container(
            // height: _authMode == AuthMode.Signup ? 320 : 260,
            height: _hightanimation.value.height,
            constraints:
            BoxConstraints(minHeight:_hightanimation.value.height //_authMode == AuthMode.Signup ? 320 : 260//
            ),
            width: deviceSize.width * 0.75,
            padding: EdgeInsets.all(16.0),

      child:ch ),child:Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  enabled: _authMode == AuthMode.Signup,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }

                  }
                      :  null,

                ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  child:
                  Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                ),
              FlatButton(
                child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                onPressed: _switchAuthMode,
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
      ),
      )

    );
  }
}
