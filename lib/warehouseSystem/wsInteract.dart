import 'package:mysql1/mysql1.dart';
import 'package:wms_app/secrets/WMS_Katsumi_Database_Settings.dart';
import 'package:wms_app/stores/versionStore.dart';
import 'package:mysql_client/mysql_client.dart';
import 'dart:async';
import 'package:synchronized/synchronized.dart';
import 'package:wms_app/utils.dart';

import '../types.dart';

class WSInteract {
  static ConnectionSettings _connectionSettings = new ConnectionSettings(
    host: WMSKatsumiDatabaseSettings.host,
    port: WMSKatsumiDatabaseSettings.port,
    user: WMSKatsumiDatabaseSettings.user,
    password: WMSKatsumiDatabaseSettings.pass,
    db: VersionStore.instance.getDatabase(),
  );

  // local sql for emebedded test sample mock database...

  static Lock _lock = Lock();
  static Future<Iterable<Model>> remoteSql(String sql) =>
      _lock.synchronized(() async {
        print(sql);
        var remote = await MySQLConnection.createConnection(
            host: WMSKatsumiDatabaseSettings.host,
            port: WMSKatsumiDatabaseSettings.port,
            userName: WMSKatsumiDatabaseSettings.user,
            password: WMSKatsumiDatabaseSettings.pass,
            databaseName: VersionStore.instance.getDatabase(),
            secure: false);
        await remote.connect();
        Iterable<Model> data = Iterable.empty();
        try {
          var rawResults = await remote.execute(sql);
          // shy do some queries reslts in no results?
          if (rawResults.isEmpty) {
            return List.empty();
          }

          var results = extractResults(rawResults);

          var models = results.last.toModels();
          await remote.close();
          return models;
        } catch (e) {
          print("failed query...");
          print(sql);
          print(e);
          print("---------------");
          await remote.close();
          return data;
        }
      });
  static List<IResultSet> extractResults(IResultSet resultSet) {
    var multiStatementQueryResult = resultSet.iterator.toList();
    if (multiStatementQueryResult.length > 0) {
      return multiStatementQueryResult.last.toList();
    }

    return [resultSet];
  }
}

enum ConnectionType { remote, local }
