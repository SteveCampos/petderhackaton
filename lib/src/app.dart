import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'screen/add_adoption.dart';
import 'screen/add_missing.dart';
import 'login.dart';
import 'screen/adoption_pet.dart' as adoption;
import 'screen/missing_pet.dart' as missing;



final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class App extends StatefulWidget {

  App({this.user,this.googleSignIn});

  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin{


  TabController controller;

  @override
  void initState(){
    controller = TabController(length:2, vsync: this);
    super.initState();


  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final menuButton = Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            modalAdd(context);
          },
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text("Petder",textAlign: TextAlign.center,),
        actions: <Widget>[
          menuButton
        ],
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: controller,
          tabs: <Widget>[
            Tab(icon:Icon(Icons.pets),text: "Adóptame",),
            Tab(icon:Icon(Icons.location_searching),text: "Me perdí",),
          ],
        ),
      ),

      drawer: Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(widget.user.displayName),
                  accountEmail: Text(widget.user.email),
                  currentAccountPicture: ClipOval(
                    child: Image.network(widget.user.photoUrl),
                  )
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text("Ver mis publicaciones")),
                          IconButton(icon: Icon(Icons.view_list), onPressed: (){
                          })
                        ],
                      ),
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text("Cerrar Sesión")),
                              IconButton(icon: Icon(Icons.exit_to_app),
                                onPressed: (){
                                  _signOut(context);
                                })
                            ]),
                        ),
                      ]),
                  ],),
              ],

            ),
          ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          adoption.Adoption(),
          missing.Miss(),
        ],
      ),
    );
  }

  void modalAdd(BuildContext context){
    var alertModal = AlertDialog(
      title: Center(
        child: Text('¿Qué deseas hacer?',style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
        ),),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             RaisedButton(
                  color: Colors.purple,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddAdoption()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:8.0),
                    child: Text('Dar mascota en Adopción',style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                    )),
                  )
              ),
             RaisedButton(
                 color: Colors.green,
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => AddMissing()));
                 },
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical:8.0),
                   child: Text('Reportar mascota Perdida',style: TextStyle(
                     fontSize: 12,
                     color: Colors.white,
                   ),
                   ),
                 )
             ),
          ],
         ),
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertModal;
        }
    );
  }

  void _signOut(BuildContext context){
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
        height: 260,
          child: Column(
                children: <Widget>[
                  ClipOval(
                    child: Image.network(widget.user.photoUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("¿Deseas cerrar Sesión?",style: TextStyle(fontSize: 16.0),),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          widget.googleSignIn.signOut();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context)=> LoginScreen())
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.check),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                            ),
                            Text("Si")
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.close),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                            ),
                            Text("Cancelar")
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
          )
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialog;
        }
    );
  }


}


