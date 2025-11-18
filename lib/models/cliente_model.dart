import 'package:my_route_movil/models/user_info_model.dart';

class Cliente {
  final String cedula;
  final String username;
  final String password;
  final String nombre;
  final String nombrePersonaContacto;
  final String correo;
  final String telefono;
  final String telefonoPersonaContacto;
  final UserInfo usuario;
  final DateTime fechaNacimiento;
  final bool activo;

  Cliente({
    required this.cedula,
    required this.username,
    required this.password,
    required this.nombre,
    required this.nombrePersonaContacto,
    required this.correo,
    required this.telefono,
    required this.telefonoPersonaContacto,
    required this.usuario,
    required this.fechaNacimiento,
    required this.activo,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      // Usamos el operador ?? para asignar un valor por defecto si el campo es nulo.
      cedula: json['cedula'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      nombre: json['nombre'] ?? '',
      nombrePersonaContacto: json['nombre_persona_contacto'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      telefonoPersonaContacto: json['telefono_persona_contacto'] ?? '',
      usuario: UserInfo.fromJson(json['usuario']),
      fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
      activo: json['activo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'username': username,
      'password': password,
      'nombre': nombre,
      'nombre_persona_contacto': nombrePersonaContacto,
      'correo': correo,
      'telefono': telefono,
      'telefono_persona_contacto': telefonoPersonaContacto,
      'usuario': usuario.toJson(),
      'fechaNacimiento': fechaNacimiento.toIso8601String().split('T').first,
      'activo': activo,
    };
  }
}
