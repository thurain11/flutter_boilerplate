import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  String noteTable = 'offline_table';
  String obId = 'obId';
  String carNo = 'car_number';
  String carNoPrefix = 'car_number_prefix';
  String product = 'product';
  String mmk = 'mmk';
  String remark = 'remark';
  String fuelbuyingObjective = 'fuelbuyingObjective';
  String tankType = 'tankType';
  String datetime = 'datetime';
  String fuelName = 'fuelName';
  String tankName ='tankName';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'testing.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database database, int version) async {
          await database.execute(
              'CREATE TABLE $noteTable($obId TEXT PRIMARY KEY, $carNo TEXT, $carNoPrefix TEXT, '
                  '$product TEXT, $mmk TEXT, $remark TEXT, $fuelbuyingObjective TEXT, $tankType TEXT, '
                  '$datetime TEXT,$fuelName TEXT, $tankName TEXT )');
          print("Success create");
        });
  }

  Future close() async {
    final db = await database;
    db.close();
  }

  // Future<int> insertUser(OfflineOb user) async {
  //   final db = await database;
  //   return await db.insert('offline_table', user.toMap());
  // }
  //
  // Future<OfflineOb> getUser(int obId) async {
  //   final db = await database;
  //   final maps = await db.query('offline_table',
  //       where: 'obId = ?', whereArgs: [obId], limit: 1);
  //
  //   if (maps.isNotEmpty) {
  //     return OfflineOb.fromMap(maps.first);
  //   }
  //
  //   throw Exception('User not found');
  // }
  //
  // Future<List<OfflineOb>> getAllUsers() async {
  //   final db = await database;
  //   final maps = await db.query('offline_table'); //it is mapping list value
  //   print("get all user is work");
  //   return List.generate(maps.length, (i) {
  //     return OfflineOb.fromMap(maps[i]);
  //   });
  // }
  //
  // Future<int> updateUser(OfflineOb user) async {
  //   final db = await database;
  //   return await db.update('offline_table', user.toMap(),
  //       where: 'obId = ?', whereArgs: [user.obId]);
  // }
  //
  // Future<int> deleteUser(String obId) async {
  //   final db = await database;
  //   return await db
  //       .delete('offline_table', where: 'obId = ?', whereArgs: [obId]);
  // }


  // Future<void> deleteDataInRange(List<OfflineOb> list) async {
  //   final db = await database;
  //   final formattedStartDate = list[0].datetime;
  //   String formattedEndDate = list[list.length-1].datetime;
  //   print(formattedStartDate);
  //   print(formattedEndDate);
  //   int listLength = list.length;
  //   print("delete method is work");
  //   if(list.length>1){
  //     String placeholders = list.map((e) => " '${e.obId}' ").join(',');
  //     print(placeholders);
  //     await db.rawQuery('DELETE FROM offline_table WHERE obId IN ($placeholders)');
  //   }
  //   else{
  //     await db.delete(
  //       'offline_table', // table_name
  //       where: 'datetime == ?',
  //       whereArgs: [formattedStartDate],
  //     );
  //   }
  // }
}
