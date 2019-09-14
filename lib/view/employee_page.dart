import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/employee.dart';

class EmployeePage extends StatefulWidget {
  EmployeePage({@required this.employee});

  final Employee employee;

  @override
  _EmployeePageState createState() => _EmployeePageState(employee);
}

class _EmployeePageState extends State<EmployeePage> {
  _EmployeePageState(this.employee);

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Employee Detail'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Center(
              child: Hero(
                tag: employee.id,
                child: Material(
                  shape:
                      CircleBorder(side: BorderSide(color: Colors.redAccent)),
                  child: ClipOval(
                    child: Image.memory(
                      base64Decode(employee.avatar),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
