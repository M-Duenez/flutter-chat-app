import 'package:http/http.dart' as http;
import 'package:chat_online/global/enviroment.dart';
import 'package:chat_online/models/usuario.dart';
import 'package:chat_online/models/usuarios_response.dart';

import 'package:chat_online/services/auth_service.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final token = await AuthService.getToken();
      final uri = Uri.parse('${Enviroments.apiUrl}/usuarios');
      final resp = await http.get(
        uri,
        headers: {'Content-type': 'application/json', 'x-token': token},
      );
      // print(resp.body);
      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios!;
    } catch (e) {
      return [];
    }
  }

  /*Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');

    final uri = Uri.parse('${Enviroments.apiUrl}/login/renew');

    final resp = await http.get(
      uri,
      headers: {
        'Content-type': 'application/json',
        'x-token': token.toString()
      },
    );
    // print(resp.body);

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      //TODO:Guardar token en ligar seguro
      await this._guardartoken(loginResponse.token);
      return true;
    } else {
      this._logout();

      return false;
    }
  }*/
}
