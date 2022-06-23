import 'package:mysql1/mysql1.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';
import 'package:wms_app/stores/versionStore.dart';
//import 'package:mysql_client/mysql_client.dart';
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
          var results = await remote.queryMulti(sql, []);

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

/*
  static Lock _lock = Lock();
  static Future<Iterable<Model>> remoteSql<Model>(String sql) =>
      _lock.synchronized(() async {
        print(sql);
        var remote = await MySQLConnection.createConnection(
            host: WMSKatsumiDatabaseSettings.host,
            port: WMSKatsumiDatabaseSettings.port,
            userName: WMSKatsumiDatabaseSettings.user,
            password: WMSKatsumiDatabaseSettings.pass,
            databaseName: VersionStore.instance.getDatabase());

        await remote.connect();

        Iterable<Model> data = Iterable.empty();
        try {
          var results = await remote.execute(sql);
          results.
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
      */
}

enum ConnectionType { remote, local }
