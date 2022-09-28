import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class ButtonGrande extends StatelessWidget {
  final String titulo;
  final VoidCallback? onPressed;
  const ButtonGrande({Key? key, required this.titulo, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return ProgressButton.icon(iconedButtons: {
      ButtonState.idle: IconedButton(
          text: "Send",
          icon: Icon(Icons.send, color: Colors.white),
          color: Colors.deepPurple.shade500),
      ButtonState.loading:
          IconedButton(text: "Loading", color: Colors.deepPurple.shade700),
      ButtonState.fail: IconedButton(
          text: "Failed",
          icon: Icon(Icons.cancel, color: Colors.white),
          color: Colors.red.shade300),
      ButtonState.success: IconedButton(
          text: "Success",
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          color: Colors.green.shade400)
    }, onPressed: (){}), state: ButtonState.idle);*/

    return Container(
      width: 370.0,
      height: 60.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(231, 31, 118, 1))),
          onPressed: onPressed,
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white, /*, color: Color.fromRGBO(92, 78, 154, 1)*/
            ),
          ),
        ),
      ),
    );
  }
}
