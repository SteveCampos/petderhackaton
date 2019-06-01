import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'detail_missing_pet.dart';

class Miss extends StatefulWidget {
  @override
  _MissState createState() => _MissState();
}

class _MissState extends State<Miss> {
  final db = Firestore.instance;
  String id;

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      StreamBuilder<QuerySnapshot>(
        stream: db.collection('buscados').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
              return Hero(
                tag: "ClaveHero",
                child: Column(
                    children: snapshot.data.documents
                        .map((doc) => buildItem(doc))
                        .toList()),
              );
          } else {
            return SizedBox();
          }
        },
      ),
    ]);
  }

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: new InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DetailMissingPet(
                  '${doc.data['foto']}',
                  '${doc.data['nombre']}',
                  '${doc.data['animal']}',
                  '${doc.data['amo']}',
                  '${doc.data['fecha_perdida']}',
                  '${doc.data['recompensa']}',
                  '${doc.data['ult_vez_vista']}',
                  '${doc.data['edad']}',
                  '${doc.data['nro_contacto']}'
              )
          )
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 2.0, left: 2.0),
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
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
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
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Text(
                              '${doc.data['nombre']}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Text(
                              'Me perdí el día ${doc.data['fecha_perdida']}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Text(
                              'Mi Amo es  ${doc.data['amo']}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
