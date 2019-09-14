import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syndicate_login/database/database.dart';
import 'package:syndicate_login/model/employee.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:syndicate_login/view/employee_page.dart';
import '../widget/loader.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  List<Employee> empList = new List();
  bool isLoading = true;
  CameraPosition initialCameraPosition =
      new CameraPosition(target: LatLng(12.9716, 77.5946), zoom: 12);
  Completer completer;
  LatLng syndicateDitLatLng = LatLng(12.9441011, 77.6212545);
  bool isListPressed = false;

  @override
  void initState() {
    super.initState();
    getEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isListPressed ? 'Employees' : 'Home'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                isListPressed ? Icons.location_on : Icons.list,
                color: Colors.white,
              ),
              onPressed: () async {
                setState(() {
                  isListPressed = !isListPressed;
                });
//                GoogleMapController controller = await _controller.future;
//                CameraPosition syndicateDitPosition =
//                    new CameraPosition(target: syndicateDitLatLng, zoom: 18);
//                controller.animateCamera(
//                    CameraUpdate.newCameraPosition(syndicateDitPosition));
              }),
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
      drawer: Drawer(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/logo.png')),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          isListPressed
              ? RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.separated(
                    itemCount: empList.length,
                    itemBuilder: (context, index) {
                      Employee employee = empList[index];
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                          child: ListTile(
                            isThreeLine: true,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EmployeePage(employee: employee)));
                            },
                            leading: Hero(
                              tag: employee.id,
                              child: Material(
                                shape: CircleBorder(
                                    side: BorderSide(color: Colors.redAccent)),
                                child: ClipOval(
                                  child: Image.memory(
                                    base64Decode(employee.avatar),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(employee.name),
                            subtitle:
                                Text(employee.email + '\n' + employee.mobile),
                          ),
                          color: index.isEven
                              ? Colors.grey.shade100
                              : Colors.white,
                        ),
                        actions: <Widget>[
                          IconSlideAction(
                            caption: 'Share',
                            color: Colors.indigo,
                            icon: Icons.share,
                            onTap: () {
                              Share.share(
                                  employee.name + ', ' + employee.mobile);
                            },
                          ),
                        ],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () async {
                              await SyndicateDatabase.get()
                                  .removeEmployeeData(employee.id.toString())
                                  .then((_) {
                                setState(() {
                                  empList.removeAt(index);
                                });
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Employee ${employee.name} has been removed.")));
                              });
                            },
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0.5,
                      );
                    },
                  ),
                )
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: initialCameraPosition,
                  markers: _createMarker(),
                  onMapCreated: (GoogleMapController controller) {
                    if (_controller == null) _controller.complete(controller);
                  },
                ),
          isLoading ? Loader() : SizedBox()
        ],
      ),
      floatingActionButton: isLoading || !isListPressed
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, 'create_employee');
                if (result != null && result == 'refresh') {
                  _handleRefresh();
                }
              },
              backgroundColor: isLoading ? Colors.grey : Colors.red,
              child: Icon(Icons.add),
            ),
    );
  }

  Set<Marker> _createMarker() {
    return empList.map<Marker>((employee) {
      return Marker(
          markerId: MarkerId(employee.id.toString()),
          position: employee.latLong,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: employee.name));
    }).toSet();
  }

  getEmployees({bool forceReload}) async {
    if (forceReload == null) {
      await databaseCall();
    } else if (forceReload) {
      empList.clear();
    }

    if (empList.length == 0) {
      apiCall();
    } else {
      setState(() {
        if (completer != null) {
          completer.complete(null);
        }
        isLoading = false;
      });
    }
  }

  databaseCall() async {
    await SyndicateDatabase.get().getEmployeeList().then((list) {
      setState(() {
        empList = list;
      });
    });
  }

  apiCall() async {
    Map<String, String> data = {'action': 'READALL'};
    await Dio()
        .post('https://webapp.syndicatebank.in/api/employees.php',
            data: FormData.from(data))
        .then((response) async {
      if (response != null) {
        print(response.data);
        List<dynamic> list = json.decode(response.data)['data'];
        setState(() {
          empList = list.map<Employee>((jsonItem) {
            return Employee.fromJson(jsonItem);
          }).toList();
        });
        await SyndicateDatabase.get().truncateEmloyeesTable();
        await SyndicateDatabase.get().insertEmployees(empList).then((_) {
          setState(() {
            if (completer != null) {
              completer.complete(null);
            }
            isLoading = false;
          });
        });
      } else {
        print('Response is null');
      }
    });
  }

  Future<Null> _handleRefresh() async {
    completer = new Completer<Null>();
    await getEmployees(forceReload: true);
    return completer.future.then((_) {});
  }
}
