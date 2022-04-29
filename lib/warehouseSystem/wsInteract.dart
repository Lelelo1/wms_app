import 'package:mysql1/mysql1.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';
import 'package:wms_app/stores/versionStore.dart';

class WSInteract {
  static ConnectionSettings _connectionSettings = new ConnectionSettings(
      host: WMSKatsumiDatabaseSettings.host,
      port: WMSKatsumiDatabaseSettings.port,
      user: WMSKatsumiDatabaseSettings.user,
      password: WMSKatsumiDatabaseSettings.pass,
      db: VersionStore.instance.getDatabase());

  static Future<List<T>> remoteSql<T>(String sql) async {
    var remote = await MySqlConnection.connect(_connectionSettings);
    print(sql);

    var data = List<T>.empty();

    try {
      var results = await remote.query(sql);
      data = Deserialize.remote<T>(results); // crash;
    } catch (e) {
      print("failed query...");
      print(sql);
      print("---------------");
    }
    remote.close(); // <----- !
    return data;
  }
/*
  static Future<List<T>> localSql<T>(String sql) async {
    var local = await openDatabase("");
    var s = await local.query(sql);
    //var results = await remote.query(sql);
    //var data = Deserialize.remote<T>(results);

    // close
    return List.empty();
  }
  */
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
