import 'package:ssh/ssh.dart';
import 'package:wms_app/secrets.dart';

class SSH {
  static SSHClient _client;

  static Future<String> connecting;
  static void openConnection() {
    var sshSettings = Secrets.ssh;

    _client = new SSHClient(
        host: sshSettings.url,
        port: sshSettings.port,
        username: sshSettings.user,
        passwordOrKey: sshSettings.pass);

    connecting = _client.connect();
  }
}

// "session_connected" indicates being connected: https://github.com/shaqian/flutter_ssh/issues/1
