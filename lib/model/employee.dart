import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Employee {
  static final db_id = "emp_id";
  static final db_name = "emp_name";
  static final db_avatar = "emp_avatar";
  static final db_mobile = "emp_mobile";
  static final db_address = "emp_address";
  static final db_dob = "emp_dob";
  static final db_email = "emp_email";
  static final db_lat = "emp_lat";
  static final db_long = "emp_long";

  int id;
  String name;
  String avatar;
  String mobile;
  String address;
  String email;
  String dob;
  LatLng latLong;

  Employee({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.address,
    this.dob,
    this.latLong,
    this.avatar,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => new Employee(
        id: json["empid"],
        name: json["ename"],
        mobile: json["mobile"],
        email: json["emailid"],
        address: json['address'],
        latLong: LatLng(json['latt'], json['long']),
        dob: json['date_of_birth'],
        avatar: json["profilepic"],
      );

  Map<String, dynamic> toJson() => {
        "empid": id,
        "ename": name,
        "mobile": mobile,
        "addr": address,
        "email": email,
        "dob": DateFormat('yyyy-MM-dd').format(DateTime.parse(dob)),
        "latt": latLong.latitude,
        "long": latLong.longitude,
        "profilepic": avatar,
      };

  Employee.map(dynamic obj) {
    this.id = int.parse(obj[db_id]);
    this.name = obj[db_name];
    this.mobile = obj[db_mobile];
    this.email = obj[db_email];
    this.avatar = obj[db_avatar];
    this.address = obj[db_address];
    this.dob = obj[db_dob];
    this.latLong = LatLng(double.parse(obj[db_lat]), double.parse(obj[db_long]));
  }

  Map<String, dynamic> toMap() {
    return {
      db_id: id,
      db_name: name,
      db_mobile: mobile,
      db_email: email,
      db_avatar: avatar,
      db_address: address,
      db_lat: latLong.latitude,
      db_long: latLong.longitude
    };
  }

  static List<Employee> fromJsonArray(String jsonString) =>
      (json.decode(jsonString)['data'] as List)
          .map((item) => Employee.fromJson(item as Map<String, dynamic>))
          .toList();
}