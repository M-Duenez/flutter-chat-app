import 'dart:io';

import 'package:chat_online/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  String? _usuarioNombre = 'Hailee Steinfeld';
  Color _color_btn = Color.fromARGB(255, 49, 4, 251);
  final _textChatController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;

  AnimationController? animationController;

  List<ChatMessage> _messages = [
    /*ChatMessage(texto: 'Hola mundo', uuid: '123'),
    ChatMessage(texto: 'Cruel y Feo', uuid: '12'),
    ChatMessage(texto: 'No exageres', uuid: '123'),
    ChatMessage(texto: '....', uuid: '123'),*/
  ];

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    //print(_screenSize);
    //final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 239, 239, 1),
      appBar: AppBar(
        centerTitle: false,
        foregroundColor: _color_btn,
        elevation: 1.0,
        backgroundColor: Colors.white,
        //fromRGBO(92, 78,
        title: ListTile(
          leading: CircleAvatar(
              child: Text(_usuarioNombre.toString().substring(0, 2))),
          // CircleAvatar(backgroundImage: AssetImage('assets/img/friend.jpg')),
          title: Text(
            _usuarioNombre.toString(),
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
                //Parte del chat pasado donde agregamos widgets
                //de mensaje por mensaje
                /*padding: EdgeInsets.only(left: 15, right: 15),
                children: <Widget>[
                  _mensajeFriend(context, "Hola, Como estas ?"),
                  _mensajePropio(context, "Hola, Bien y tu ?"),
                  _mensajeFriend(context, "Que haces?"),
                  _mensajePropio(context, "Hola, Bien y tu ?"),
                ],*/
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
                  onChanged: (String valor) {
                    setState(() {
                      if (valor.length > 0) {
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

  _eventoBtnSubmit(String valor) {
    print(valor);
    _textChatController.clear();
    _focusNode.requestFocus();

    if (valor.length == 0) return;
    final _newMessage = new ChatMessage(
      uuid: '123',
      texto: valor,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)),
    );

    _messages.insert(0, _newMessage);
    _newMessage.animationController?.forward().orCancel;

    setState(() {
      _estaEscribiendo = false;
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
                    /*Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(92, 78, 154, 1),

                      //=> Navigator.pushReplacementNamed(context, 'Login'),
                    ),*/
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
    super.dispose();
  }
}
