import 'package:chat_online/models/usuario.dart';
import 'package:chat_online/services/auth_service.dart';
import 'package:chat_online/services/chat_service.dart';
import 'package:chat_online/services/socket_service.dart';
import 'package:chat_online/services/usuarios_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuariosService = UsuariosService();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  // final usuarios = [
  //   Usuario(
  //       uid: '1', online: true, nombre: 'Miguel', email: 'Miguel@outlook.com'),
  //   Usuario(
  //       uid: '2',
  //       online: false,
  //       nombre: 'Armando',
  //       email: 'Armando@outlook.com'),
  //   Usuario(
  //       uid: '3', online: true, nombre: 'Daniel', email: 'Daniel@outlook.com'),
  //   Usuario(
  //       uid: '4', online: false, nombre: 'Teresa', email: 'Teresa@outlook.com'),
  //   Usuario(
  //       uid: '5', online: true, nombre: 'Maria', email: 'Maria@outlook.com'),
  // ];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authservice = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authservice.usuario;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            usuario?.nombre ?? 'Sin nombre',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red[900],
            ),
            onPressed: () {
              // TODO: Desconectar del socket server
              Navigator.pushReplacementNamed(context, 'Login');
              AuthService.deleteToken();
              socketService.disConnect();
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: //TODO:: Validacion de conexion de server
                  (socketService.serverStatus == ServerStatus.Online)
                      ? Icon(Icons.check_circle, color: Colors.blue[400])
                      : Icon(Icons.offline_bolt, color: Colors.red),
              // Icon(Icons.check_circle, color: Colors.blue[400]),
              //child: Icon(Icons.offline_bolt, color: Colors.red,),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            waterDropColor: Colors.blue,
          ),
          child: _ListViewUsuarios(),
        ));
  }

  ListView _ListViewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _UsuarioListTitle(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _UsuarioListTitle(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text('Nuevos Mensajes'),
      leading: CircleAvatar(child: Text(usuario.nombre.substring(0, 2))),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: (() {
        // print(usuario.nombre);
        final chatServices = Provider.of<ChatServices>(context, listen: false);
        chatServices.usuarioPara = usuario;
        Navigator.pushNamed(context, 'Chat');
      }),
    );
  }

  _cargarUsuarios() async {
    usuarios = await usuariosService.getUsuarios();
    setState(() {});
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
