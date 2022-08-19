import 'dart:io';
import 'dart:math';

import 'package:chat_online/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:chat_online/pages/usuarios_page.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  String _nombre = '', _apellido = '', _email = '', _password = '';
  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0.0,
        //COLOR DE FONDO DE LA APP
        backgroundColor: Color.fromRGBO(92, 78, 154, 0),
        /*toolbarHeight: 130.0,

        //title: _crearFondo(context),
        flexibleSpace: _crearFondo(context, _screenSize),*/
      ),
      backgroundColor: Color.fromARGB(255, 37, 9, 158),
      body: Stack(
        children: [
          //_crearFondo(context, _screenSize),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _crearFondo(BuildContext context, Size screenSize) {
    final size = MediaQuery.of(context).size;
    final fondo_morado = Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: Color.fromRGBO(92, 78, 154, 1)),
    );

    final forma_fondo = Transform.rotate(
        angle: -pi / 1.0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0), color: Colors.white),
          width: screenSize.width,
          height: 200.0,
        ));

    return Stack(
      children: <Widget>[
        fondo_morado,
        Positioned(top: -50.0, child: forma_fondo),
        /*Positioned(top: 30.0, left: -70.0, child: circulo),
        Positioned(bottom: -30.0, right: 10.0, child: circulo),
        Positioned(top: -60.0, right: -50.0, child: circulo),
        Positioned(bottom: -30.0, left: 30.0, child: circulo),*/
        Container(
          padding: EdgeInsets.only(top: 40.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 20.0,
              ),
              Icon(Icons.person_pin_circle, color: Colors.black, size: 100.00),
              SizedBox(
                width: 30.0,
              ),
              Text(
                'Galaspace',
                style: TextStyle(
                  color: Color.fromRGBO(62, 38, 105, 1),
                  fontSize: 40.0,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final authservice = Provider.of<AuthService>(context);
    //final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: 50.0,
          )),
          Container(
            width: 370.0,
            child: Text(
              "Crear una nueva cuenta",
              style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontFamily: 'ArialRoundedMTBold'),
            ),
          ),
          SafeArea(
              child: Container(
            height: 50.0,
          )),
          //_crearEmail(),
          Container(
            width: 370.0,
            child: Column(
              children: <Widget>[
                _crearNombre(),
                SizedBox(
                  height: 30.0,
                ),
                /*_crearApellidos(),
                SizedBox(
                  height: 30.0,
                ),*/
                _crearEmail(),
                SizedBox(
                  height: 30.0,
                ),
                _crearPassword(),

                //_crearBoton(),
              ],
            ),
          ),
          SizedBox(height: 100.0),
          FlatButton(
            height: 60.0,
            minWidth: 370.0,
            textColor: Colors.white,
            color: Color.fromRGBO(231, 31, 118, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            onPressed: (authservice.autenticando)
                ? null
                : () async {
                    print('$_nombre  $_email  $_password');
                    FocusScope.of(context).unfocus();

                    final registrando = await authservice.registro(
                        _nombre.trim(), _email.trim(), _password.trim());

                    if (registrando == true) {
                      print('Correcto');
                      // Navegar a otra pantalla
                      // TODO: Conectar ala socket server
                      Navigator.pushReplacementNamed(context, 'Usuarios');
                    } else {
                      // Mostrar alert
                      print('Error');
                      //Navigator.pushReplacementNamed(context, 'Perfil');
                      if (Platform.isAndroid) {
                        return mostrarAlerta(context, registrando);
                      } else {
                        mostrarAlertaIOS(context, registrando);
                      }
                    }
                  },
            child: Text(
              'Crear Cuenta',
              style: TextStyle(
                  fontSize: 25.0 /*, color: Color.fromRGBO(92, 78, 154, 1)*/),
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _crearNombre() {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 20.0),
      //height: 600.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 30.0),
        child: TextField(
          autofocus: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            //contentPadding: EdgeInsets.only(left: 20.0),
            icon: Icon(
              Icons.person,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            hintText: 'ej. Juan Carlos',
            labelText: 'Nombre',
            errorText: (_nombre.length == 3) ? 'Nombre no es Correcto' : null,
          ),
          onChanged: (valor) {
            setState(() {
              _nombre = valor;
            });
          },
        ),
      ),
    );
  }

  Widget _crearApellidos() {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 20.0),
      //height: 600.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 30.0),
        child: TextField(
          autofocus: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            //contentPadding: EdgeInsets.only(left: 20.0),
            icon: Icon(
              Icons.person,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            hintText: 'ej. Gonzalez Paz',
            labelText: 'Apellidos',
            errorText:
                (_apellido.length == 3) ? 'Apellido no es Correcto' : null,
          ),
          onChanged: (valor) {
            setState(() {
              _apellido = valor;
            });
          },
        ),
      ),
    );
  }

  Widget _crearEmail() {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 20.0),
      //height: 600.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 30.0),
        child: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              return TextField(
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 20.0),
                  icon: Icon(
                    Icons.email,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Email',
                  errorText:
                      (!EmailValidator.validate(_email) && _email.length > 5)
                          ? 'Email no es Correcto'
                          : null,
                ),
                onChanged: (valor) {
                  setState(() {
                    _email = valor;
                  });
                },
              );
            }),
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 30.0),
        child: TextField(
          autofocus: false,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(
              Icons.lock,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            labelText: 'Password',
            errorText:
                (/*!validateStructure(_password) &&*/ _password.length >= 3 &&
                        _password.length <= 5)
                    ? 'Contraseña Incorrecta ej. Vignesh123!'
                    : null,
          ),
          onChanged: (valor) {
            setState(() {
              _password = valor;
            });
          },
        ),
      ),
    );
  }

  Widget _crearBoton() {
    final authservice = Provider.of<AuthService>(context);
    //fromValidStream
    return StreamBuilder(
        stream: null,
        builder: (context, snapshot) {
          return ElevatedButton(
              child: Container(
                width: 370.0,
                height: 60.0,
                //padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Center(
                    child: Text(
                  'GUARDAR',
                  style: TextStyle(
                      fontSize:
                          25.0 /*, color: Color.fromRGBO(92, 78, 154, 1)*/),
                )),
              ),
              style: ButtonStyle(
                foregroundColor:
                    getColor(Color.fromRGBO(92, 78, 154, 1), Colors.white),
                backgroundColor: getColor(Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(92, 78, 154, 1)),
                side: getBorde(Color.fromRGBO(92, 78, 154, 1), Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.red)),
                ),
              ),
              onPressed: authservice.autenticando == true
                  ? null
                  : () async {
                      print('$_nombre  $_email  $_password');
                      FocusScope.of(context).unfocus();

                      final registrando = await authservice.registro(
                          _nombre.trim(), _email.trim(), _password.trim());

                      if (registrando) {
                        // Navegar a otra pantalla
                        // TODO: Conectar ala socket server
                        // Navigator.pushReplacementNamed(context, 'Usuarios');
                        print('Correcto');
                      } else {
                        // Mostrar alert
                        print('Error');
                        //Navigator.pushReplacementNamed(context, 'Perfil');
                        if (Platform.isAndroid) {
                          return mostrarAlerta(context, 'Revise sus Campos');
                        } else {
                          mostrarAlertaIOS(context, 'Revise sus Campos');
                        }
                      }
                      //Navigator.pushReplacementNamed(context, 'Home');
                    });
        });
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPresionado) {
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPresionado;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorde(
      Color color, Color colorPresionado) {
    final getBorde = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return BorderSide(color: colorPresionado, width: 2);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorde);
  }
}
