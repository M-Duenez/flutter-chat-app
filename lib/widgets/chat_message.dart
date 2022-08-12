import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String? uuid;
  final String? texto;
  final AnimationController? animationController;

  const ChatMessage({
    Key? key,
    @required this.uuid,
    @required this.texto,
    @required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: this.uuid == '123'
              ? _mensajePropio(context, texto.toString())
              : _mensajeFriend(context, texto.toString()),
        ),
      ),
    );
  }

  Widget _mensajeFriend(BuildContext context, String mns) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 24, 7, 95),
        ),
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 40),
        //height: 40.0,
        child: Text(
          mns,
          style:
              TextStyle(color: Colors.white, fontFamily: 'Arial', fontSize: 16),
        ),
      ),
    );
  }

  Widget _mensajePropio(BuildContext context, String mns) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 37, 9, 158),
        ),
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 20),
        // width: 70,
        //height: 40,
        child: Text(
          mns,
          style:
              TextStyle(color: Colors.white, fontFamily: 'Arial', fontSize: 16),
        ),
      ),
    );
  }
}
