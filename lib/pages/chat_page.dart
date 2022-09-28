import 'dart:async';
import 'dart:io';

import 'package:chat_online/services/auth_service.dart';
import 'package:chat_online/services/socket_service.dart';
import 'package:chat_online/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mensajes_response.dart';
import '../services/chat_service.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  // String? _usuarioNombre = 'Hailee Steinfeld';
  Color _color_btn = Color.fromARGB(255, 49, 4, 251);
  final _textChatController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;

  AnimationController? animationController;

  ChatServices? chatServices;
  SocketService? socketService;
  AuthService? authService;

  List<ChatMessage> _messages = [];
  String? _timeString;

  @override
  void initState() {
    super.initState();
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());

    chatServices = Provider.of<ChatServices>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService?.socket.on('mensaje-personal', _escucharMensaje);

    _cargarMensajes(chatServices?.usuarioPara?.uid);
  }

  void _getCurrentTime() {
    setState(() {
      _timeString = "${DateTime.now().hour}:${DateTime.now().minute}";
    });
  }

  void _cargarMensajes(String? UsuarioID) async {
    List<Mensaje>? chat = await chatServices?.getChat(UsuarioID!);
    // print(_timeString.toString());
    final historial = chat!.map((msg) => ChatMessage(
        uuid: msg.de,
        texto: msg.mensaje,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 50),
        )..forward()));

    setState(() {
      _messages.insertAll(0, historial);
    });
  }

  void _escucharMensaje(dynamic payload) {
    print('tengo mensaje $payload');
    // Verificamos que el mensaje sea para la conversacion actual
    if (payload['de'] != chatServices?.usuarioPara?.uid) return;

    ChatMessage message = ChatMessage(
      uuid: payload['de'],
      texto: payload['mensaje'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)),
    );
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatServices?.usuarioPara;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 219, 219),
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: _color_btn,
        elevation: 1.0,
        backgroundColor: Colors.white,
        //fromRGBO(92, 78,
        title: ListTile(
          leading:
              CircleAvatar(child: Text(usuarioPara!.nombre.substring(0, 2))),
          // CircleAvatar(backgroundImage: AssetImage('assets/img/friend.jpg')),
          title: Text(
            usuarioPara.nombre,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Arial',
              color: Color.fromARGB(255, 31, 3, 154),
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(right: 8.0, left: 8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
              ),
            ),
            SizedBox(height: 15),
            //TODO:Parte de Imput del chat de texto
            _inputChat(),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return Container(
      color: Colors.white,
      height: 93.0,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Container(
                width: 281,
                child: TextField(
                  controller: _textChatController,
                  onSubmitted: _eventoBtnSubmit,
                  onChanged: (String texto) {
                    setState(() {
                      if (texto.length > 0) {
                        _estaEscribiendo = true;
                      } else {
                        _estaEscribiendo = false;
                      }
                    });
                  },
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hoverColor: _color_btn,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Escribir Mensaje',
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: Platform.isIOS
                    ? null
                    : EdgeInsets.only(right: 5.0, bottom: 9.0),
                child: Platform.isIOS
                    ? CupertinoButton(
                        child: Text('Enviar'),
                        onPressed: _estaEscribiendo
                            ? () => _eventoBtnSubmit(
                                _textChatController.text.trim())
                            : null,
                      )
                    : _btnEnviarMensaje(),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _eventoBtnSubmit(String texto) {
    // print(texto);
    _textChatController.clear();
    _focusNode.requestFocus();

    if (texto.length == 0) return;
    final _newMessage = new ChatMessage(
      uuid: authService?.usuario?.uid.toString(),
      texto: texto,
      hora: _timeString,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)),
    );

    _messages.insert(0, _newMessage);
    _newMessage.animationController?.forward().orCancel;

    setState(() {
      _estaEscribiendo = false;
    });

    socketService?.emitir('mensaje-personal', {
      'de': authService?.usuario?.uid,
      'para': chatServices?.usuarioPara?.uid,
      'mensaje': texto
    });
  }

  Widget _btnEnviarMensaje() {
    return Container(
      child: IconTheme(
        data: IconThemeData(color: _color_btn),
        child: IconButton(
          icon: Icon(
            Icons.send,
            // color: _color_btn,
            size: 42,
          ),
          onPressed: _estaEscribiendo
              ? () => _eventoBtnSubmit(_textChatController.text.trim())
              : null,
        ),
      ),
    );
  }

  Widget _crearAppBar(BuildContext context, String title) {
    return Container(
      height: 84.0,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              child: Container(
                //color: Colors.red,
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/img/friend.jpg"),
                    ),
                  ],
                ),
              ),
              onTap: () {},
              // onTap: () => Navigator.pushReplacementNamed(context, 'OPerfil'),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Color.fromRGBO(92, 78, 154, 1), fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: Off del socket

    // TODO: Limpiar el char para evitar consumo de memoria
    for (ChatMessage message in _messages) {
      message.animationController?.dispose();
    }
    socketService?.socket.off('mensaje-personal');
    super.dispose();
  }
}
