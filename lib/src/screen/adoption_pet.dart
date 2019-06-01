import 'package:adoptame/src/screen/detail_adoption_pet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Adoption extends StatefulWidget {

  @override
  _AdoptionState createState() => _AdoptionState();
}

class _AdoptionState extends State<Adoption> {

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('adoptame').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.documents.map((doc) =>
                    buildItem(doc)).toList());
              } else {
                return SizedBox();
              }
            },
          ),
        ]
    );
  }

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DetailAdoptionPet(
                '${doc.data['animal']}',
                '${doc.data['edad']}',
                '${doc.data['encargado']}',
                '${doc.data['estado']}',
                '${doc.data['foto']}',
                '${doc.data['nombre']}',
                '${doc.data['sexo']}',
                '${doc.data['nro_contacto']}',
              )
          )
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, left: 5.0, right: 5.0, bottom: 15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(10000.0),
                      child: CachedNetworkImage(
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill,
                        imageUrl: "${doc.data['foto']}",
                        placeholder: (context,
                            url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                        new Icon(Icons.error),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 7.0, top: 2.0, right: 7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 7.0),
                        child: Text("${doc.data['nombre']}", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45)),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 7.0),
                        child: Text('Sexo: ${doc.data['sexo']}',
                          style: TextStyle(fontSize: 14),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 7.0),
                        child: Text('Dueño temporal: ${doc.data['encargado']}',
                            style: TextStyle(fontSize: 14)),
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.arrow_forward,color: Colors.purple,),
                      ]
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


