import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailAdoptionPet extends StatefulWidget {
  DetailAdoptionPet(this.animal,this.edad,this.encargado,this.estado, this.foto,this.nombre,this.sexo,this.nro_contacto);
  String animal,edad,encargado,estado,foto,nombre,sexo, nro_contacto;

  @override
  _DetailAdoptionPetState createState() => _DetailAdoptionPetState();
}
class _DetailAdoptionPetState extends State<DetailAdoptionPet> {
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles Mascota"),
      ),
      body: ListView(
          children: <Widget>[
            Container(
              child:  StreamBuilder<QuerySnapshot>(
                stream: db.collection('adoptame').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildItem(widget.animal,widget.edad,widget.encargado,widget.estado,widget.foto,widget.nombre,widget.sexo, widget.nro_contacto);
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ]
      ),
    );
  }


  Card buildItem(String animal, String edad, String encargado, String estado , String foto , String nombre, String sexo ,String nro_contacto){
    void _showDialog(){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('¿Usted desea adoptar a '+ nombre + '?',style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                  fontSize: 24,
                  fontStyle: FontStyle.normal
              ),),
              actions: <Widget>[
                FlatButton(
                  child: Text('SI, CONTACTAR'),
                  onPressed: (){
                    launch("tel://"+nro_contacto);
                  },
                ),
                FlatButton(
                  child: Text('NO'),
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          }
      );
    }
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(11),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.fill,
                      imageUrl: foto,
                      placeholder: (context, url) => new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),
                  ),
                  SizedBox(height: 40.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(nombre,style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 32)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Container(
                                  child: Text(animal+', '+edad+' años',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w600,fontSize: 16)),
                                )
                            ),
                            Expanded(
                              child: Container(
                                  child: RaisedButton(
                                    onPressed: (){
                                      _showDialog();
                                    },
                                    child: Text("Adoptar",style: TextStyle(color: Colors.white),),
                                    color: Colors.deepPurple,
                                  )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(),
                        ListTile(
                          dense: true,
                          title: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.justify,
                                softWrap: true,
                                text: TextSpan(children: <TextSpan>
                                [
                                  TextSpan(text: 'Hola soy '+nombre+' me encuentro buscando hogar.' ,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500)),

                                ]
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Container(
                                  child: Text('Dueño temporal: '+encargado,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w400,fontSize: 14)),
                                )
                            ),
                            Expanded(
                              child: Container(
                                  child: Container(
                                    child: Text('Estado: '+ estado,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w400,fontSize: 14)),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )
      ),
    );

  }


}


