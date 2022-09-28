import 'package:chat_online/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String? uuid;
  final String? texto;
  final String? hora;
  final AnimationController? animationController;

  const ChatMessage({
    Key? key,
    @required this.uuid,
    @required this.texto,
    @required this.hora,
    @required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context, listen: false);

    Animation<double>? animation;

    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController!);

    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: Container(
          child: uuid == authServices.usuario?.uid
              ? _mensajePropio(context, texto.toString(), hora)
              : _mensajeFriend(context, texto.toString(), hora),
        ),
      ),
    );
  }

  Widget _mensajeFriend(BuildContext context, String mns, String? hora) {
    return Container(
      // alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              margin: EdgeInsets.all(8.0),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 40),
              //height: 40.0,
              child: Text(
                mns,
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Arial', fontSize: 16),
              ),
            ),
          ),
          /*Align(
            alignment: Alignment.centerLeft,
            child: Container(
              // alignment: Alignment.topRight,
              margin: EdgeInsets.only(left: 25.0),
              child: Text(
                hora.toString(),
                // textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Arial', fontSize: 13),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _mensajePropio(BuildContext context, String mns, String? hora) {
    return Container(
      // alignment: Alignment.centerRight,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 201, 235, 176),
              ),
              margin: EdgeInsets.all(8.0),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 20),
              // width: 70,
              //height: 40,
              child: Text(
                mns,
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Arial', fontSize: 16),
              ),
            ),
          ),
          /*Align(
            alignment: Alignment.centerRight,
            child: Container(
              // alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: 20.0),
              child: Text(
                hora.toString(),
                // textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Arial', fontSize: 13),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
