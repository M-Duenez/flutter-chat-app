import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isNumero(String s) {
  if (s.isEmpty) return false;
  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_sharp,
            size: 100.0,
            color: Colors.white,
          ),
          AlertDialog(
            backgroundColor: Color.fromARGB(204, 232, 27, 38),
            title: Text(
              'Mensaje de Alerta',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
            content: Text(mensaje,
                style: TextStyle(fontSize: 25.0, color: Colors.white)),
            actions: <Widget>[
              Container(
                width: 140.0,
                height: 40.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cerrar',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
                height: 60,
              ),
            ],
          ),
        ],
      );
    },
  );
}

void mostrarAlertaIOS(BuildContext context, String mensaje) {
  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text('Mensaje de alerta'),
      content: Text(mensaje),
      actions: [
        CupertinoDialogAction(
          child: Text('OK'),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}
