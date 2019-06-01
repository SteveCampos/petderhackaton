import 'package:flutter/material.dart';

import 'PetWidgets.dart';
import 'models.dart';
import 'package:adoptame/Bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adopatame',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Adóptame'),
      ),
      body: streamPets(),
    );
  }

  Widget streamPets() {
    print('streamPets');
    return StreamBuilder<List<Pet>>(
      stream: bloc.getAllPets(),
      builder: (context, asyncSnap) {
        if (!asyncSnap.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children:
              asyncSnap.data.map((p) => _buildPetItem(context, p)).toList(),
        );
      },
    );
  }

  Widget _buildPetItem(BuildContext context, Pet p) {
    print('_buildPetItem');
    return ListTile(
      leading: avatar(p.avatarUrl),
      title: new Text('${p.name}'),
      subtitle: new Text(p.reference.documentID),
    );
  }
}
