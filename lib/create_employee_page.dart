import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:syndicate_login/text_validators.dart';

import 'loader.dart';

class CreateEmployeePage extends StatefulWidget {
  @override
  _CreateEmployeePageState createState() => _CreateEmployeePageState();
}

class _CreateEmployeePageState extends State<CreateEmployeePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _form = new GlobalKey<FormState>();
  bool _autovalidate = false;
  bool isLoading = false;
  bool isPassportAvailable = true;
  bool isMale = true;
  File avatar;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Employee'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: avatar == null
                              ? Icon(
                                  Icons.person,
                                  size: 55,
                                )
                              : Image.file(
                                  avatar,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                            key: _form,
                            autovalidate: _autovalidate,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextFormField(
                                  validator: TextValidators.validateMandatory,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    prefixIcon: Icon(Icons.person),
                                    hintText: 'Name',
                                  ),
                                  onSaved: (text) {},
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  validator: TextValidators.validateMandatory,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      prefixIcon: Icon(Icons.phone),
                                      hintText: 'Mobile'),
                                  onSaved: (text) {},
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  validator: TextValidators.validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      prefixIcon: Icon(Icons.alternate_email),
                                      hintText: 'Email'),
                                  onSaved: (text) {},
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  validator: TextValidators.validateMandatory,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      prefixIcon: Icon(Icons.location_city),
                                      hintText: 'City'),
                                  onSaved: (text) {},
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  validator: TextValidators.validateMandatory,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      prefixIcon: Icon(Icons.location_city),
                                      hintText: 'State'),
                                  onSaved: (text) {},
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  validator: TextValidators.validateMandatory,
                                  keyboardType: TextInputType.emailAddress,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      prefixIcon: Icon(Icons.home),
                                      hintText: 'Address'),
                                  onSaved: (text) {},
                                ),
                                ListTile(
                                  contentPadding:
                                      EdgeInsets.only(top: 20, bottom: 0),
                                  leading: IconButton(
                                      icon: Icon(Icons.people),
                                      onPressed: null),
                                  title: Text('Gender'),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      child: RadioListTile(
                                        groupValue: isMale,
                                        value: true,
                                        title: Text('Male'),
                                        onChanged: (bool value) =>
                                            setState(() => isMale = true),
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile(
                                        groupValue: isMale,
                                        value: false,
                                        title: Text('Female'),
                                        onChanged: (bool value) =>
                                            setState(() => isMale = false),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black87,
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.only(top: 10),
                                  leading: IconButton(
                                      icon: Icon(Icons.recent_actors),
                                      onPressed: null),
                                  title: Text('Passport Available'),
                                  trailing: Switch(
                                    onChanged: (bool value) =>
                                        setState(() => isPassportAvailable = false),
                                    value: isPassportAvailable,
                                  ),
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                                RaisedButton(
                                  onPressed: () {},
                                  elevation: 15,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      'Submit',
                                      style: textTheme.subhead
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  color: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          isLoading ? Loader() : SizedBox()
        ],
      ),
    );
  }
}
