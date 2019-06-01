import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget avatar(String avatar, {double radius: 12}) {
  return Container(
    width: radius * 2,
    height: radius * 2,
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 14),
    alignment: Alignment.center,
    child: CircleAvatar(
      foregroundColor: Colors.white,
      radius: radius,
      backgroundColor: Colors.white,
      backgroundImage: new NetworkImage('$avatar'),
    ),
  );
}
