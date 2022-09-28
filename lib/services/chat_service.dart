import 'package:chat_online/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/enviroment.dart';
import '../models/usuario.dart';
import 'auth_service.dart';

class ChatServices with ChangeNotifier {
  Usuario? usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('${Enviroments.apiUrl}/mensajes/$usuarioID');

    final resp = await http.get(
      uri,
      headers: {'Content-type': 'application/json', 'x-token': token},
    );
    final mensajeResponse = mensajesResponseFromJson(resp.body);

    return mensajeResponse.mensajes;
  }
}
