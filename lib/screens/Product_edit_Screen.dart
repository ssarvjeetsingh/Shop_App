import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/provider/proviver_product.dart';

class EditPrdct extends StatefulWidget{
  static const routeName="/editscreen";
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StateEditPrdct();
  }

}

class StateEditPrdct extends State<EditPrdct> {
  final priceFocus=FocusNode();
  final descriptionFocus=FocusNode();
  var imagecontroller=TextEditingController();
  final imageFocus=FocusNode();
  final formkey=GlobalKey<FormState>();
  var isinitstate=true;

  Product editprdct=Product(id: null,title: '',description: '',price: null,imageUrl: '');

   var initvalues={
     'title':'',
     'description':'',
     'price':'',
     'imageurl':''
   };

   var isloading=false;
  @override
  void initState() {
    // TODO: implement initState
    imageFocus.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(isinitstate)
      {
        final editProductid=ModalRoute.of(context).settings.arguments as String;
        if(editProductid!=null)
          {
            editprdct=Provider.of<Productp>(context,listen: false).item.firstWhere((prd){
              return prd.id==editProductid;
            });
            initvalues={
              'title':editprdct.title,
              'description':editprdct.description,
              'price':editprdct.price.toString(),
              'imageurl':''
            };
            print(initvalues['price']);
            imagecontroller.text=editprdct.imageUrl;
          }
      }

       isinitstate=false;


    super.didChangeDependencies();
  }
  @override
  void dispose()
  {
    imageFocus.removeListener(updateImage);
   priceFocus.dispose();
   descriptionFocus.dispose();
   imagecontroller.dispose();
   super.dispose();
  }

  void updateImage()
  {
    if(!imageFocus.hasFocus) {
      setState(() {

      });
      }
  }
  Future<void> _onSave() async{


    final isvalidate=formkey.currentState.validate();
    if(isvalidate)
      {
        print("1");
        formkey.currentState.save();
        setState(() {
          isloading=true;
        });
      if(editprdct.id!=null)
        {
          print("2");
         await  Provider.of<Productp>(context,listen: false).udateByUser(editprdct.id,editprdct);
          setState(() {
            isloading=false;
          });
          Navigator.of(context).pop();

        }
        else
          {
            try{
              print("3");
              await Provider.of<Productp>(context,listen: false).
              addProductUser(editprdct);
              print("hello");

            }
            catch(error){
                await showDialog(context: context,builder: (ctxx)=>  //it also return future
                    AlertDialog(title: Text("error occur"),content: Text("Somehting wrong"),
                      actions: <Widget>[
                        FlatButton(
                            child:Text("ok",style: TextStyle(color:Theme.of(context).accentColor),),
                            onPressed: (){
                              Navigator.of(ctxx).pop();
                            }
                        )
                      ],

                    )
                );
                }finally{
              //invisible wrap with then like belwo
              setState(() {
                isloading=false;
              });
              Navigator.of(context).pop();

            }
                //.then((_){
    //setState(() {
    //isloading=false;
    //});
    //Navigator.of(context).pop();
           // });
          }
      }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: (){
            _onSave();
          })
        ],
      ),

      body: isloading?Center(child: CircularProgressIndicator(),):
      Padding(
        padding: EdgeInsets.all(15),
      child:Form(
        key: formkey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: initvalues['title'],
            decoration:InputDecoration(labelText: "Title"),
              validator:(value){
              if(value.isEmpty){
                return "please enter this field";
              }
              return null;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(priceFocus);
              },
              onSaved: (value){
              editprdct=Product(
                  id: editprdct.id,
                  title: value,
                  description: editprdct.description,
                  price: editprdct.price,
                  imageUrl: editprdct.imageUrl,
                  isFavrite: editprdct.isFavrite
              );
              },
            ),
            TextFormField(
              initialValue: initvalues['price'],
              decoration:InputDecoration(labelText: "Price"),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: priceFocus,

                validator:(value){
                  if(value.isEmpty){
                    return "please enter this field";
                  }
                  if(double.parse(value)<=0)
                    {
                      return "please enter price greater then 0";
                    }
                  if(double.tryParse(value)==null){
                    return "please enter valid price";
                  }
                  return null;
                },
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(descriptionFocus);
                },
                onSaved: (value){

                    editprdct=Product(
                    id: editprdct.id,
                    title: editprdct.title,
                    description: editprdct.description,
                    price: double.parse(value),
                     imageUrl: editprdct.imageUrl,
                        isFavrite: editprdct.isFavrite
               );
               }
            ),
            TextFormField(
              initialValue: initvalues['description'],
              decoration:InputDecoration(labelText: "Description"),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              focusNode: descriptionFocus,

                validator:(value){
                  if(value.isEmpty){
                    return "please enter this field";
                  }
                  if(value.length<10)
                    {
                      return "discription must contain at least 10 words";
                    }
                  return null;
                },
                onSaved: (value){
                  editprdct=Product(
                      id: editprdct.id,
                      title: editprdct.title,
                      description: value,
                      price: editprdct.price,
                      imageUrl: editprdct.imageUrl,
                      isFavrite: editprdct.isFavrite
                  );
                }
            ),
            Row(
              crossAxisAlignment:CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(top: 8,right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 1),
                  ),
                  child:imagecontroller.text.isEmpty?Text("please enter image Url"):FittedBox(
                    child: Image.network(imagecontroller.text),
                    fit: BoxFit.cover,
                  ) ,
                ),
               Expanded(
                   child:TextFormField(
                 decoration:InputDecoration(labelText: "Image Url"),
                 keyboardType: TextInputType.url,
                     textInputAction: TextInputAction.done,
                     controller: imagecontroller,
                     focusNode: imageFocus,

                     validator:(value){
                       if(value.isEmpty){
                         return "please enter this field";
                       }
                       if(!value.startsWith("http")&&!value.startsWith("https"))
                         {
                           return "enter valid url";
                         }
                      // if(!value.endsWith("png")&&!value.endsWith("jpg"))
                        // {
                          // return "enter valid url";
                        // }
                       return null;
                     },

                     onSaved: (value){
                         editprdct=Product(
                             id: editprdct.id,
                             title: editprdct.title,
                             description: editprdct.description,
                             price: editprdct.price,
                             imageUrl: value,
                             isFavrite: editprdct.isFavrite
                         );
                       },
                     onFieldSubmitted: (_){
                        _onSave();
                     },
               )
               )
              ],
            )
          ],
        ),
      ) ,
      ),
    );
  }

}