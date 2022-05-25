import 'package:mysql1/mysql1.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';
import 'package:wms_app/stores/versionStore.dart';
import 'package:wms_app/utils/default.dart';
import 'dart:async';
import 'package:synchronized/synchronized.dart';

typedef Model = Map<String, dynamic>;

class WSInteract {
  static ConnectionSettings _connectionSettings = new ConnectionSettings(
      host: WMSKatsumiDatabaseSettings.host,
      port: WMSKatsumiDatabaseSettings.port,
      user: WMSKatsumiDatabaseSettings.user,
      password: WMSKatsumiDatabaseSettings.pass,
      db: VersionStore.instance.getDatabase());

  static Lock _lock = Lock();
  static Future<Iterable<Model>> remoteSql<Model>(String sql) =>
      _lock.synchronized(() async {
        var remote = await MySqlConnection.connect(_connectionSettings);
        print(sql);

        Iterable<Model> data = Iterable.empty();
        try {
          var results = await remote.query(sql);
          data = results.map((row) => row.fields).cast<Model>();
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

  // local sql for emebedded test sample mock database...

}

enum ConnectionType { remote, local }
