import 'package:mysql1/mysql1.dart';
import 'package:wms_app/models/model.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';
import 'package:wms_app/stores/versionStore.dart';
import 'package:wms_app/utils/default.dart';
import 'dart:async';
import 'package:synchronized/synchronized.dart';

class WSInteract {
  static ConnectionSettings _connectionSettings = new ConnectionSettings(
      host: WMSKatsumiDatabaseSettings.host,
      port: WMSKatsumiDatabaseSettings.port,
      user: WMSKatsumiDatabaseSettings.user,
      password: WMSKatsumiDatabaseSettings.pass,
      db: VersionStore.instance.getDatabase());

  static Lock _lock = Lock();
  static Future<List<T>> remoteSql<T>(String sql) =>
      _lock.synchronized(() async {
        var remote = await MySqlConnection.connect(_connectionSettings);
        print(sql);

        var data = List<T>.empty();
        try {
          var results = await remote.query(sql);
          data = Deserialize.remote<T>(results);
          remote.close();
          return data;
        } catch (e) {
          print("failed query...");
          print(sql);
          print(e);
          print("---------------");
          remote.close();
          return data;
        }
      });
      
  static Future<M> fetchModel<M extends Model>(Model model) {
    model.
  }

  // local sql for emebedded test sample mock database...


}

enum ConnectionType { remote, local }

class Deserialize<T> {
  static List<T> remote<T>(Results results) {
    if (results == null) {
      return List.empty();
    }

    if (results.isEmpty) {
      return List.empty();
    }

    results.forEach((element) {
      element.fields.forEach((key, value) {
        print("key: " + key.toString() + ", " + value.toString());
      });
    });

    return results.map((e) => Default.nullSafe<T>(e[0])).toList();
  }
}
