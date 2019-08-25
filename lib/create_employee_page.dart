import 'package:flutter/material.dart';

class CreateEmployeePage extends StatefulWidget{
  @override
  _CreateEmployeePageState createState() => _CreateEmployeePageState();
}

class _CreateEmployeePageState extends State<CreateEmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create'),),
      body: Center(),
    );
  }
}