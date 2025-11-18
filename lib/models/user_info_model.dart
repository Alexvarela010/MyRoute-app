class UserInfo {
  final String cedula;
  final String email;
  final String nombre;
  final String username;
  final String password;
  final DateTime fechaNacimiento;
  final String roles;
  final bool activo;
  final String telefono;
  final String infoAdicional;
  final String telPersonaContacto;
  final String nombrePersonaContacto;
  final String tipoSangre;

  UserInfo({
    required this.cedula,
    required this.email,
    required this.nombre,
    required this.username,
    required this.password,
    required this.fechaNacimiento,
    required this.roles,
    required this.activo,
    required this.telefono,
    required this.infoAdicional,
    required this.telPersonaContacto,
    required this.nombrePersonaContacto,
    required this.tipoSangre,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      // Usamos el operador ?? para asignar un valor por defecto si el campo es nulo.
      cedula: json['cedula'] ?? '',
      email: json['email'] ?? '',
      nombre: json['nombre'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      // Para la fecha, si es nula, podríamos usar una fecha por defecto o manejarlo como nulable.
      // Por ahora, asumimos que siempre vendrá una fecha válida.
      fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
      roles: json['roles'] ?? 'ROLE_USER',
      activo: json['activo'] ?? false,
      telefono: json['telefono'] ?? '',
      infoAdicional: json['info_adicional'] ?? '',
      telPersonaContacto: json['tel_persona_contacto'] ?? '',
      nombrePersonaContacto: json['nombre_persona_contacto'] ?? '',
      tipoSangre: json['tipo_sangre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'email': email,
      'nombre': nombre,
      'username': username,
      'password': password,
      'fechaNacimiento': fechaNacimiento.toIso8601String().split('T').first,
      'roles': roles,
      'activo': activo,
      'telefono': telefono,
      'info_adicional': infoAdicional,
      'tel_persona_contacto': telPersonaContacto,
      'nombre_persona_contacto': nombrePersonaContacto,
      'tipo_sangre': tipoSangre,
    };
  }

   // Override para comparar objetos UserInfo (útil para Set y otras colecciones)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfo &&
          runtimeType == other.runtimeType &&
          cedula == other.cedula;

  @override
  int get hashCode => cedula.hashCode;
}
