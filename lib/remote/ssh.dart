import 'package:ssh/ssh.dart';
import '../../secrets'
class SSH {
  SSHClient client;

  Future<String> connecting;
  static void openConnection() {
    Secrets
    new SSHClient()
  }
}

// "session_connected" indicates being connected: https://github.com/shaqian/flutter_ssh/issues/1
