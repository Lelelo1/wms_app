import 'package:mysql1/mysql1.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';
import 'package:wms_app/stores/versionStore.dart';
import 'package:sqflite/sqflite.dart';

class RemoteHandler {
  Future<Results?> interact<Results>(
      Future<Results>? Function(MySqlConnection? connection) action) async {
    MySqlConnection? connection;
    try {
      connection = await connect();
    } on Exception catch (exception) {
      print("failed interact. did not connect...");
      print(exception.toString());
      return null;
    }

    print("interact got connection, preforming action");
    var result = await action(connection);
    return result;
  }

  // needs internet permission android real device, otherwise: 'SocketException: OS Error: Connection refused'
  // https://stackoverflow.com/questions/55785581/socketexception-os-error-connection-refused-errno-111-in-flutter-using-djan
  // such permission is granted on install time: https://developer.android.com/training/basics/network-ops/connecting
  Future<MySqlConnection?> connect() async {
    var database = VersionStore.instance.getDatabase();
    var settings = new ConnectionSettings(
        host: WMSKatsumiDatabaseSettings.host,
        port: WMSKatsumiDatabaseSettings.port,
        user: WMSKatsumiDatabaseSettings.user,
        password: WMSKatsumiDatabaseSettings.pass,
        db: database);

    return await MySqlConnection.connect(settings);
  }
}

class Connect {
  static ConnectionSettings _connectionSettings = new ConnectionSettings(
      host: WMSKatsumiDatabaseSettings.host,
      port: WMSKatsumiDatabaseSettings.port,
      user: WMSKatsumiDatabaseSettings.user,
      password: WMSKatsumiDatabaseSettings.pass,
      db: VersionStore.instance.getDatabase());

  static Future<List<T>> remoteSql<T>(String sql) async {
    var remote = await MySqlConnection.connect(_connectionSettings);
    var results = await remote.query(sql);
    var data = Deserialize.remote<T>(results);

    remote.close();
    return data;
  }

  static Future<List<T>> localSql<T>(String sql) async {
    var local = await openDatabase("");
    var s = await local.query(sql);
    //var results = await remote.query(sql);
    //var data = Deserialize.remote<T>(results);

    // close
    return List.empty();
  }
}

enum ConnectionType { remote, local }

class Deserialize<T> {
  static List<T> remote<T>(Results results) {
    if (results.isEmpty) {
      return List.empty();
    }

    return results.map((e) => (e[0] as T)).toList();
  }
}
