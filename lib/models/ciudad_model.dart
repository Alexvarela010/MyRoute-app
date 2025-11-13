import 'package:my_route_movil/models/departamento_model.dart';

class Ciudad {
  final int id;
  final String ciudad;
  final Departamento departamento;

  Ciudad({
    required this.id,
    required this.ciudad,
    required this.departamento,
  });

  factory Ciudad.fromJson(Map<String, dynamic> json) {
    return Ciudad(
      id: json['id'],
      ciudad: json['ciudad'],
      departamento: Departamento.fromJson(json['departamento']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ciudad': ciudad,
      'departamento': departamento.toJson(),
    };
  }
}
