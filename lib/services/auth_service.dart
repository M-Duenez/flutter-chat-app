import 'dart:convert';

import 'package:chat_online/models/login_response.dart';
import 'package:chat_online/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:chat_online/global/enviroment.dart';

class AuthService with ChangeNotifier {
  //type Usuario Usuario final
  Usuario? usuario;
  bool _autenticando = false;

  //Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //Geters del token de forma estatica
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future login(String email, String password) async {
    this.autenticando = true;
    final Object? data = {'email': email, 'password': password};

    final uri = Uri.parse('${Enviroments.apiUrl}/login');

    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'},
    );
    // print(resp.body);
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      //TODO:Guardar token en ligar seguro
      await this._guardartoken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future registro(String nombre, String email, String password) async {
    this.autenticando = true;
    final Object? data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${Enviroments.apiUrl}/login/new');

    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'},
    );
    // print(resp.body);
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      //TODO:Guardar token en ligar seguro
      await this._guardartoken(loginResponse.token);
      return true;
    } else {
      // print(resp.body);
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
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
  }

  Future _guardartoken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    // Delete value
    await _storage.delete(key: 'token');
  }
}
