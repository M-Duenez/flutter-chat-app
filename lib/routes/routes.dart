import 'package:chat_online/pages/chat_page.dart';
import 'package:chat_online/pages/loading_page.dart';
import 'package:chat_online/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';

import '../pages/login_page.dart';
import '../pages/registro_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'Usuarios': (_) => UsuariosPage(),
  'Login': (_) => LoginPage(),
  'Registro': (_) => RegistroPage(),
  'Chat': (_) => ChatPage(),
  'Loading': (_) => LoadingPage(),
};
