import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sql.dart';
import 'package:synchronized/synchronized.dart';
import 'package:syndicate_login/model/employee.dart';

class SyndicateDatabase {
  static final SyndicateDatabase _syndicateDatabase =
      new SyndicateDatabase._internal();

  Database db;
  bool didInit = false;
  Directory documentsDirectory;
  String path;

  static final String TABLE_EMPLOYEE = "Employees";

  static SyndicateDatabase get() {
    return _syndicateDatabase;
  }

  final _lock = new Lock();

  SyndicateDatabase._internal();

  // Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async {
    if (!didInit) await _init();
    return db;
  }

  Future _init() async {
    // Get a location using path_provider
    documentsDirectory = await getApplicationDocumentsDirectory();
    print('Directory: ' + documentsDirectory.toString());
    path = join(documentsDirectory.path, "syndicate.db");
    if (db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (db == null) {
          db = await openDatabase(path,
              version: 6, onCreate: _onCreate, onUpgrade: _onUpgrade);
        }
      });
    }
    didInit = true;
  }

  _onCreate(Database db, int version) async {
    //CREATE TABLES
    print("DB: Database Created $version");

    await db.execute("CREATE TABLE $TABLE_EMPLOYEE ("
        "id INTEGER,"
        "${Employee.db_id} TEXT,"
        "${Employee.db_name} TEXT,"
        "${Employee.db_email} TEXT,"
        "${Employee.db_mobile} TEXT,"
        "${Employee.db_address} TEXT,"
        "${Employee.db_avatar} TEXT,"
        "${Employee.db_lat} TEXT,"
        "${Employee.db_long} TEXT"
        ")");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("DB: Database Upgraded from $oldVersion to $newVersion");

    await db.execute(
        "ALTER TABLE " + TABLE_EMPLOYEE + " ADD COLUMN " + "id INTEGER;");
  }

  Future insertEmployeeData(Employee employee) async {
    var db = await _getDb();

    await db.transaction((txn) async {
      await txn.insert(TABLE_EMPLOYEE, employee.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('Inserted ' + employee.name);
    });
  }

  Future removeEmployeeData(String employeeId) async {
    var db = await _getDb();

    await db.transaction((txn) async {
      await txn.delete(TABLE_EMPLOYEE,
          where: "${Employee.db_id} = ?", whereArgs: [employeeId]);
      print('Deleted ' + employeeId);
    });
  }

  Future<bool> insertEmployees(List<Employee> employeeList) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      employeeList.forEach((employee) {
        batch.insert(TABLE_EMPLOYEE, employee.toMap());
        print('Inserted ' + employee.name);
      });
      await batch.commit(noResult: true);
    });
    return true;
  }

  Future<List<Employee>> getEmployeeList() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT DISTINCT * FROM $TABLE_EMPLOYEE ORDER BY ${Employee.db_id}');
    List<Employee> empList = List();
    for (int i = 0; i < result.length; i++) {
      empList.add(Employee.map(result[i]));
    }
    return empList;
  }

  Future dropEmployeesTable() async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.execute("DROP TABLE IF EXISTS $TABLE_EMPLOYEE");
    });
  }

  Future truncateEmloyeesTable() async {
    var db = await _getDb();
    await db.transaction((txn) async {
      await txn.delete(TABLE_EMPLOYEE);
    });
  }
}
