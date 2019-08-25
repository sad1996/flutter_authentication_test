import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'employees_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (dialogContext) {
                    return SimpleDialog(
                      title: Text('Do you want to logout?'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                            ),
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                Navigator.pop(dialogContext);
                                SharedPreferences _pref =
                                    await SharedPreferences.getInstance();
                                _pref.clear();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            )
                          ],
                        )
                      ],
                    );
                  });
            },
          )
        ],
      ),
      drawer: Drawer(),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => EmployeesPage()));
        Navigator.pushNamed(context, 'employees');
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
