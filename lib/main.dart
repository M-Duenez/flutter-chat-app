import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_online/routes/routes.dart';
import 'package:chat_online/services/auth_service.dart';
import 'package:chat_online/services/chat_service.dart';
import 'package:chat_online/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatServices()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'Loading',
        routes: appRoutes,
      ),
    );
  }
}
