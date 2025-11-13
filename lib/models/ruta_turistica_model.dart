class RutaTuristica {
  final int idRutaTuristica;
  final String titulo;
  final String descripcion;
  final DateTime fechaCreacion;
  final int cantDias;
  final bool estado;
  final int extras;
  final String imgUrl; // Nuevo campo para la imagen

  RutaTuristica({
    required this.idRutaTuristica,
    required this.titulo,
    required this.descripcion,
    required this.fechaCreacion,
    required this.cantDias,
    required this.estado,
    required this.extras,
    required this.imgUrl, // Añadido al constructor
  });

  factory RutaTuristica.fromJson(Map<String, dynamic> json) {
    return RutaTuristica(
      idRutaTuristica: json['id_rutaturistica'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      // Asumiendo que el backend envía la fecha como un String en formato ISO 8601
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      cantDias: json['cant_dias'],
      estado: json['estado'],
      extras: json['extras'],
      // Mapear el campo 'url' del JSON al campo 'imgUrl' del modelo
      imgUrl: json['url'] ?? '', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_rutaturistica': idRutaTuristica,
      'titulo': titulo,
      'descripcion': descripcion,
      // Enviar solo la parte de la fecha, sin la hora
      'fecha_creacion': fechaCreacion.toIso8601String().split('T').first,
      'cant_dias': cantDias,
      'estado': estado,
      'extras': extras,
      // Mapear el campo 'imgUrl' del modelo al campo 'url' para el JSON
      'url': imgUrl, 
    };
  }
}
