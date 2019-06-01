
import 'package:adoptame/src/app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'dart:async';
import 'dart:io';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

File image;
String filename;


class AddAdoption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dar en Adopción'),
      ),
      body: Add(),
    );
  }
}


class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {

  List _animals = ["Perro", "Gato", "Loro", "Hanster"];
  List _estado = ["Adoptado", "En Adopción"];
  List _sexo = ["Macho", "Hembra"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentAnimal;

  List<DropdownMenuItem<String>> _dropDownMenuItemsEstado;
  String _currentEstado;

  List<DropdownMenuItem<String>> _dropDownMenuItemsSexo;
  String _currentSexo;

  @override
  void initState(){
    _dropDownMenuItems = getDropDownMenuItems();
    _currentAnimal = _dropDownMenuItems[0].value;

    _dropDownMenuItemsEstado = getDropDownMenuItemsEstado();
    _currentEstado = _dropDownMenuItemsEstado[0].value;

    _dropDownMenuItemsSexo = getDropDownMenuItemsSexo();
    _currentSexo = _dropDownMenuItemsSexo[0].value;

    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String animal in _animals) {
      items.add(new DropdownMenuItem(
          value: animal,
          child: new Text(animal)
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsEstado() {
    List<DropdownMenuItem<String>> items = new List();
    for (String estado in _estado) {
      items.add(new DropdownMenuItem(
          value: estado,
          child: new Text(estado)
      ));
    }
    return items;
  }
  List<DropdownMenuItem<String>> getDropDownMenuItemsSexo() {
    List<DropdownMenuItem<String>> items = new List();
    for (String sexo in _sexo) {
      items.add(new DropdownMenuItem(
          value: sexo,
          child: new Text(sexo)
      ));
    }
    return items;
  }

  Future _getImage() async{
    var selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery );
    setState(() {
      image = selectedImage;
      filename = basename(image.path);
    });
  }

  String id;
  final db =Firestore.instance;
  final _formkey = GlobalKey<FormState>();

  String nombre,animal,encargado,sexo,edad,url,estado,nro_contacto;

  @override
  Widget build(BuildContext context) {

    void _showDialog() async{

      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser firebaseUser = await auth.signInWithCredential(credential);

      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Ha sido registrado correctamente',style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                  fontSize: 24,
                  fontStyle: FontStyle.normal
              ),),
              actions: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => App(user: firebaseUser,googleSignIn: googleSignIn,)));
                      },
                      child: Center(
                          child: Icon(Icons.check_circle,color: Colors.green,size: 80,)),
                    )
                  ],
                )
              ],
            );
          }
      );
    }

    return  ListView(
        children: <Widget>[
          Form(
            key: _formkey,
            child: buildTextFormField(),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed:(){
                      createData();
                      _showDialog();
                    },
                    child: Text('Crear', style:TextStyle(color: Colors.white)),
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: (){
                      Navigator.pop(context,true);
                      },
                    child: Text('Cancelar', style:TextStyle(color: Colors.white)),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }

  buildTextFormField() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
          children: <Widget>[
            SizedBox(height: 8,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: image==null?Text("Seleccionar imagen"): uploadArea(),
                  ),
                ),
                RaisedButton(
                  color: Colors.deepPurple,
                  child: Icon(Icons.file_upload,color: Colors.white,),
                  onPressed: (){
                    _getImage();
                  },
                ),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.assignment_ind, color: Colors.deepPurple),
                labelText: 'Nombre',
              ),
              validator: (value){
                if (value.isEmpty){
                  return 'Por favor ingrese un texto';
                }
              },
              onSaved: (value) => nombre = value,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.pets, color: Colors.deepPurple),
              ),
              value: _currentAnimal,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
              onSaved: (value) => animal = value,
            ),

            SizedBox(height: 8,),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.deepPurple),
                labelText: 'Encargado',
              ),
              validator: (value){
                if (value.isEmpty){
                  return 'Por favor ingrese un texto';
                }
              },
              onSaved: (value) => encargado = value,
            ),
            SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.phone, color: Colors.deepPurple),
                labelText: 'Nro de Contácto',
              ),
              validator: (value){
                if (value.isEmpty){
                  return 'Por favor ingrese un texto';
                }
              },
              onSaved: (value) => nro_contacto = value,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.pets, color: Colors.deepPurple),
              ),
              value: _currentSexo,
              items: _dropDownMenuItemsSexo,
              onChanged: changedDropDownItemSexo,
              onSaved: (value) => sexo = value,
            ),

            SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.plus_one, color: Colors.deepPurple),
                labelText: 'Edad',
              ),
              validator: (value){
                if (value.isEmpty){
                  return 'Por favor ingrese un texto';
                }
              },
              onSaved: (value) => edad = value,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.pets, color: Colors.deepPurple),
              ),
              value: _currentEstado,
              items: _dropDownMenuItemsEstado,
              onChanged: changedDropDownItemEstado,
              onSaved: (value) => estado = value,
            ),

          ]
      ),
    );
  }

  void createData() async{
    if (_formkey.currentState.validate()){
      _formkey.currentState.save();

      StorageReference refUpload = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadImage = refUpload.putFile(image);
      var downURL = await (await uploadImage.onComplete).ref.getDownloadURL();
      url = downURL.toString();

      DocumentReference ref = await db.collection('adoptame').add({
        'nombre':'$nombre',
        'encargado' :'$encargado',
        'animal' : '$animal',
        'edad' : '$edad',
        'sexo' : '$sexo',
        'foto' : '$url',
        'estado' : '$estado',
        'nro_contacto' : '$nro_contacto',
      });
      setState(() => id = ref.documentID);
      print(ref.documentID);

    }
  }
  void readData() async{
    DocumentSnapshot snapshot =await db.collection('adoptame').document(id).get();
    print(snapshot.data['nombre']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db.collection('adoptame').document(doc.documentID).updateData({
      'nombre':'$nombre',
      'encargado' :'$encargado',
      'edad' : '$edad',
      'animal' :'$animal',
      'foto' : '$url',
      'sexo' : '$sexo',
      'estado' : '$estado',
      'nro_contacto' : '$nro_contacto',
    });
  }
  void deleteData(DocumentSnapshot doc) async {
    await db.collection('adoptame').document(doc.documentID).delete();
    setState(() => id = null);
  }

  Widget uploadArea(){
    return Container (
        child: Image.file(image, width: 80,height: 80,),
    );
  }
  void changedDropDownItem(String selectedAnimal) {
    setState(() {
      _currentAnimal = selectedAnimal;
    });
  }
  void changedDropDownItemEstado(String selectedEstado) {
    setState(() {
      _currentEstado = selectedEstado;
    });
  }
  void changedDropDownItemSexo(String selectedSexo) {
    setState(() {
      _currentSexo = selectedSexo;
    });
  }

}





