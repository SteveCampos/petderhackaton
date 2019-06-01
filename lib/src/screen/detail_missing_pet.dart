import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMissingPet extends StatefulWidget {
  DetailMissingPet(this.imagen,this.nombre,this.animal,this.amo,this.fecha_perdida,this.recompensa,this.ult_vez_vista, this.edad, this.nro_contacto);
  String imagen,nombre, animal,amo, fecha_perdida,recompensa,ult_vez_vista,edad,nro_contacto;

  @override
  _DetailMissingPetState createState() => _DetailMissingPetState();
}
class _DetailMissingPetState extends State<DetailMissingPet> {
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
              stream: db.collection('buscados').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildItem(widget.imagen,widget.nombre,widget.animal, widget.amo,widget.fecha_perdida,widget.recompensa,widget.ult_vez_vista,widget.edad,widget.nro_contacto);
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


  Card buildItem(String imagen , String nombre, String animal ,String amo, String fecha_perdida, String recompensa,String ult_vez_vista,String edad,String nro_contacto ){

    void _showDialog(){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('¿Usted tiene información sobre la mascota perdida?',style: TextStyle(
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
                    imageUrl: imagen,
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
                                child: Text(animal+', '+edad,style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w600,fontSize: 16)),
                              )
                          ),
                          Expanded(
                            child: Container(
                                child: RaisedButton(
                                  onPressed: (){
                                    _showDialog();
                                  },
                                  child: Text("Contactar",style: TextStyle(color: Colors.white),),
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
                                TextSpan(text: ult_vez_vista ,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500)),

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
                                child: Text(fecha_perdida,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w400,fontSize: 14)),
                              )
                          ),
                          Expanded(
                            child: Container(
                                child: Container(
                                  child: Text('Recompensa: '+ recompensa,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w400,fontSize: 14)),
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


