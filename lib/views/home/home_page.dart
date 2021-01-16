import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String id;
  HomePage({this.id});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HOME PAGE"),),
      body: Center(child: Text("HOME PAGE AREA")),
    );
  }
}