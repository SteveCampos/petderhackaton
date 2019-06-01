import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

final _estiloBodyText = new TextStyle (fontSize: 25, fontFamily: 'Dax-Regular', color: Colors.purple);
final _borderButton = new RoundedRectangleBorder(borderRadius:  BorderRadius.circular(20),);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
      RaisedButton(
        child: Text('Quiero Adoptar ♥ !', style: _estiloBodyText,),
        color: Colors.green,
        // podria ir un textColor: Colors.redaccent
        shape: _borderButton,
        onPressed: (){},
        ),
        RaisedButton(
        child: Text('Quiero reportar una mascota perdida !', style: _estiloBodyText,),
        color: Colors.green,
        // podria ir un textColor: Colors.redaccent
        shape: _borderButton,
        onPressed: (){},
        ),
        RaisedButton(
        child: Text('Estoy buscando Novi@♥', style: _estiloBodyText,),
        color: Colors.green,
        // podria ir un textColor: Colors.redaccent
        shape: _borderButton,
        onPressed: (){},
        ),
      ],
    );
  }
}