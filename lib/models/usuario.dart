class Usuario {
  bool online;
  String email;
  String nombre;
  String apellidos;
  String uuid;

  Usuario({
    required this.uuid,
    required this.online,
    required this.nombre,
    required this.apellidos,
    required this.email,
  });
}
