import 'dart:io';

class Enviroments {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.43.105:3000/api'
      : 'http://localhost:3000/api';

  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.43.105:3000'
      : 'http://localhost:3000';
}
